# Copyright (c) 2021 aasaam software development group
FROM ubuntu:focal AS builder

LABEL org.label-schema.name="web-server" \
      org.label-schema.description="Improved version of Nginx/OpenResty" \
      org.label-schema.url=https://github.com/aasaam/web-server \
      org.label-schema.vendor="aasaam" \
      maintainer="Muhammad Hussein Fattahizadeh <m@mhf.ir>"

ADD tools/patch-source.py /tmp/patch-source.py
ADD tools/geoip-finder.py /tmp/geoip-finder.py
RUN export DEBIAN_FRONTEND=noninteractive ; \
  export LANG=en_US.utf8 ; \
  export LC_ALL=C.UTF-8 ; \
  apt-get update -y \
  && apt-get -y upgrade \
  && apt-get install --no-install-recommends -y gnupg \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F44B38CE3DB1BF64B61DBD28DE1997DCDE742AFA \
  && echo 'deb http://ppa.launchpad.net/maxmind/ppa/ubuntu focal main' > /etc/apt/sources.list.d/maxmind.list \
  && apt-get update -y \
  && apt-get install -y build-essential bzr-builddeb ca-certificates curl dh-make dh-systemd gnupg gnupg2 jq gzip \
    libmaxminddb0 libmaxminddb-dev mmdb-bin libpcre3 libpcre3-dev libtemplate-perl lsb-release make perl python sudo systemtap-sdt-dev unzip uuid-dev wget zlib1g-dev \
  && echo "BUILD_TIME_VARIABLE" \
  ## python patch
  && cd /tmp \
  && chmod +x /tmp/patch-source.py \
  && chmod +x /tmp/geoip-finder.py \
  && curl -Ls 'https://db-ip.com/db/download/ip-to-city-lite' -o /tmp/ip-to-city-lite.html \
  && curl -Ls 'https://db-ip.com/db/download/ip-to-asn-lite' -o /tmp/ip-to-asn-lite.html \
  && wget -q -O /tmp/ip-to-city-lite.gz $(/tmp/geoip-finder.py /tmp/ip-to-city-lite.html) \
  && wget -q -O /tmp/ip-to-asn-lite.gz $(/tmp/geoip-finder.py /tmp/ip-to-asn-lite.html) \
  && gunzip /tmp/ip-to-city-lite.gz \
  && gunzip /tmp/ip-to-asn-lite.gz \
  && cd /tmp \
  && wget -q -O naxsi.tgz https://github.com/nbs-system/naxsi/archive/refs/tags/1.3.tar.gz \
  && tar -xf naxsi.tgz \
  && export NGINX_MODULE_NAXI=`realpath naxsi-1.*/naxsi_src` \
  && cd /tmp \
  && export NPS_VERSION=1.13.35.2-stable \
  && wget -q -c https://github.com/apache/incubator-pagespeed-ngx/archive/v${NPS_VERSION}.zip \
  && unzip v${NPS_VERSION}.zip \
  && export nps_dir=`realpath *pagespeed-ngx*` \
  && cd $nps_dir \
  && export NPS_RELEASE_NUMBER=$NPS_VERSION/stable/ \
  && export psol_url="https://dl.google.com/dl/page-speed/psol/$NPS_RELEASE_NUMBER.tar.gz" \
  && ls -laF scripts/ \
  && [ -e scripts/format_binary_url.sh ] && psol_url=$(scripts/format_binary_url.sh PSOL_BINARY_URL) \
  && wget -q -c ${psol_url} \
  && tar -xzvf $(basename ${psol_url}) \
  && export NGINX_MODULE_PS=`realpath "$nps_dir"` \
  && cd /tmp \
  && wget -q -O ngx_http_geoip2_module.tgz https://github.com/leev/ngx_http_geoip2_module/archive/3.3.tar.gz \
  && tar -xf ngx_http_geoip2_module.tgz \
  && export NGINX_MODULE_GEOIP2=`realpath /tmp/ngx_http_geoip2_module-*` \
  && cd /tmp \
  && git clone https://github.com/google/ngx_brotli /tmp/ngx_brotli \
  && cd /tmp/ngx_brotli \
  && git submodule update --init \
  && export NGINX_MODULE_BROTLI=`realpath /tmp/ngx_brotl*` \
  ## openresty download
  && cd /tmp \
  && wget -q -O openresty.tgz https://github.com/openresty/openresty-packaging/archive/master.tar.gz \
  && tar -xf openresty.tgz \
  && rm -rf /tmp/builder/resty \
  && mkdir -p /tmp/builder/resty \
  ## geo ip db
  && mv /tmp/ip-to-asn-lite /tmp/builder/ASN.mmdb \
  && mv /tmp/ip-to-city-lite /tmp/builder/City.mmdb \
  ## openresty
  && cd /tmp/openresty-packaging-master/deb \
  && grep -v "debsigs" Makefile > temp && cat temp > Makefile \
  && sed -i 's#OPTS=#OPTS=-b -uc -us#g' Makefile \
  && sed -i 's#tar xf openresty_$(OR_VER).orig.tar.gz --strip-components=1 -C openresty#tar xf openresty_$(OR_VER).orig.tar.gz --strip-components=1 -C openresty \&\& /tmp/patch-source.py `realpath openresty/bundle/nginx-1*/` #g' Makefile \
  && sed -i "s#--with-threads#--with-threads --with-ld-opt=\"-Wl,-rpath,$PHP_LIB\" --add-module=$NGINX_MODULE_STS --add-module=$NGINX_MODULE_BROTLI --add-module=$NGINX_MODULE_NAXI --add-module=$NGINX_MODULE_PS --add-module=$NGINX_MODULE_GEOIP2#g" openresty/debian/rules \
  && make zlib-build \
  && export DEB_TO_INSTALL=`realpath openresty-zlib_1.*.deb` \
  && export DEB_DEV_TO_INSTALL=`realpath openresty-zlib-dev_1.*.deb` \
  && cp $DEB_TO_INSTALL /tmp/builder/openresty-zlib.deb \
  && cp $DEB_DEV_TO_INSTALL /tmp/builder/openresty-zlib-dev.deb \
  && dpkg -i /tmp/builder/openresty-zlib.deb \
  && dpkg -i /tmp/builder/openresty-zlib-dev.deb \
  && sed -i 's#https://ftp.pcre.org/pub/pcre/pcre-$(PCRE_VER).tar.bz2#https://kumisystems.dl.sourceforge.net/project/pcre/pcre/$(PCRE_VER)/pcre-$(PCRE_VER).tar.bz2#g' Makefile \
  && make pcre-build \
  && export DEB_TO_INSTALL=`realpath openresty-pcre_8.*deb` \
  && export DEB_DEV_TO_INSTALL=`realpath openresty-pcre-dev_8.*.deb` \
  && cp $DEB_TO_INSTALL /tmp/builder/openresty-pcre.deb \
  && cp $DEB_DEV_TO_INSTALL /tmp/builder/openresty-pcre-dev.deb \
  && dpkg -i /tmp/builder/openresty-pcre.deb \
  && dpkg -i /tmp/builder/openresty-pcre-dev.deb \
  && make openssl111-build \
  && echo "======== DEBUG ==========" \
  && ls -la \
  && find /tmp -type f -name "*.deb" \
  && echo "======== /DEBUG ==========" \
  && export DEB_TO_INSTALL=`realpath openresty-openssl111_1.*deb` \
  && export DEB_DEV_TO_INSTALL=`realpath openresty-openssl111-dev_1*.deb` \
  && cp $DEB_TO_INSTALL /tmp/builder/openresty-openssl.deb \
  && cp $DEB_DEV_TO_INSTALL /tmp/builder/openresty-openssl-dev.deb \
  && dpkg -i /tmp/builder/openresty-openssl.deb \
  && dpkg -i /tmp/builder/openresty-openssl-dev.deb \
  && make openresty-build \
  && echo "======== DEBUG ==========" \
  && ls -la \
  && find /tmp -type f -name "*.deb" \
  && echo "======== /DEBUG ==========" \
  && export DEB_TO_INSTALL=`realpath openresty_1*focal1_amd64.deb` \
  && cp $DEB_TO_INSTALL /tmp/builder/openresty.deb \
  && export DEB_TO_INSTALL=`realpath openresty-resty_1*focal1_all.deb` \
  && cp $DEB_TO_INSTALL /tmp/builder/openresty-resty.deb \
  && export DEB_TO_INSTALL=`realpath openresty-opm_1*focal1_amd64.deb` \
  && cp $DEB_TO_INSTALL /tmp/builder/openresty-opm.deb \
  && cd /tmp \
  && wget -q -O error-pages.tgz https://github.com/aasaam/error-pages/archive/master.tar.gz \
  && tar -xf error-pages.tgz \
  && cd /tmp/error-pages-master/dist/nginx \
  && rm -rf /tmp/builder/error-pages \
  && mv error-pages /tmp/builder/ \
  && cd /tmp \
  && wget -q -O /tmp/icons.tgz https://github.com/aasaam/brand-icons/archive/master.tar.gz \
  && tar -xf /tmp/icons.tgz \
  && mv brand-icons-master/svg /tmp/builder/error-pages/ \
  && wget -q -O dl_woothee.tgz https://github.com/woothee/lua-resty-woothee/archive/refs/tags/v1.12.0-1.tar.gz \
  && tar -xf dl_woothee.tgz \
  && export WOOTHEE_PATH=`realpath /tmp/lua-resty-woothee-1*/lib` \
  && cd $WOOTHEE_PATH \
  && cp -rf resty/* /tmp/builder/resty/ \
  && cd /tmp \
  && wget -q -O lua_resty_url.tgz https://github.com/3scale/lua-resty-url/archive/refs/tags/v0.3.5.tar.gz \
  && tar -xf lua_resty_url.tgz \
  && export LUA_RESTY_URL_PATH=`realpath /tmp/lua-resty-url*/src/` \
  && cd $LUA_RESTY_URL_PATH \
  && cp -rf resty/* /tmp/builder/resty/ \
  && wget -q -O /tmp/builder/favicon.ico https://raw.githubusercontent.com/aasaam/information/master/logo/icons/favicon.ico \
  && cd /tmp \
  && tar -czf builder.tgz builder

FROM ubuntu:focal

COPY --from=builder /tmp/builder.tgz /tmp/builder.tgz
COPY --from=hairyhenderson/gomplate /gomplate /bin/gomplate
COPY entrypoint.sh /entrypoint.sh
RUN export DEBIAN_FRONTEND=noninteractive ; \
  export LANG=en_US.utf8 ; \
  export LC_ALL=C.UTF-8 ; \
  apt-get update -y \
  && apt-get -y upgrade \
  && apt-get install --no-install-recommends -y gnupg \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F44B38CE3DB1BF64B61DBD28DE1997DCDE742AFA \
  && echo 'deb http://ppa.launchpad.net/maxmind/ppa/ubuntu focal main' > /etc/apt/sources.list.d/maxmind.list \
  && apt-get update -y \
  && apt-get install --no-install-recommends -y libmaxminddb0 \
  && cd /tmp/ \
  && tar -xf builder.tgz \
  && dpkg -i /tmp/builder/openresty-zlib.deb \
  && dpkg -i /tmp/builder/openresty-pcre.deb \
  && dpkg -i /tmp/builder/openresty-openssl.deb \
  && dpkg -i /tmp/builder/openresty.deb \
  && dpkg -i /tmp/builder/openresty-resty.deb \
  && dpkg -i /tmp/builder/openresty-opm.deb \
  && cp /tmp/builder/resty/* /usr/local/openresty/lualib/resty/ -rf \
  && cp /tmp/builder/error-pages /usr/local/openresty/nginx/ -rf \
  && rm -rf /usr/local/openresty/nginx/conf \
  && mkdir -p /usr/local/openresty/nginx/conf \
  && mkdir -p /usr/local/openresty/nginx/addon \
  && export OPENSSL_BIN=`find /usr/local/openresty -type f -executable -name openssl` \
  && cp /tmp/builder/favicon.ico /usr/local/openresty/nginx/favicon.ico \
  # geoip
  && mkdir /GeoIP2 \
  && cp /tmp/builder/*.mmdb /GeoIP2/ \
  && mkdir -p /usr/local/openresty/addon-generated/sites-enabled \
  && mkdir -p /usr/local/openresty/htpasswd \
  && printf "monitoring:$($OPENSSL_BIN passwd -apr1 monitoring)\n" > /usr/local/openresty/htpasswd/monitoring.htpasswd \
  && echo "======== VERSION ==========" \
  && /usr/bin/openresty -V 2>&1 | tee /tmp/VERSION \
  && cat /tmp/VERSION \
  && echo "======== /VERSION ==========" \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /usr/share/doc \
  && rm -rf /usr/share/man \
  && rm -rf /usr/share/locale \
  && rm -rf /root/.op* \
  && cd / \
  && rm -r /var/lib/apt/lists/* && rm -rf /tmp && mkdir /tmp && chmod 777 /tmp && truncate -s 0 /var/log/*.log \
  && find /usr/local/openresty/nginx/error-pages -type f -print0 | xargs -0 chmod 0644 \
  && find /usr/local/openresty/lualib -type d -print0 | xargs -0 chmod 0755 \
  && find /usr/local/openresty/lualib -type f -print0 | xargs -0 chmod 0644 \
  && chmod +x /entrypoint.sh

# defaults config
COPY config/defaults /usr/local/openresty/nginx/defaults

# lua scripts
COPY config/lua/access_normal.lua /usr/local/openresty/lualib/access_normal.lua
COPY config/lua/normalize.lua /usr/local/openresty/lualib/normalize.lua
COPY config/lua/locales.lua /usr/local/openresty/lualib/locales.lua
COPY config/lua/utils.lua /usr/local/openresty/lualib/utils.lua
COPY config/lua/browsers.lua /usr/local/openresty/lualib/browsers.lua
COPY config/lua/loading_page.lua /usr/local/openresty/lualib/loading_page.lua

# nginx.conf
COPY addon /usr/local/openresty/nginx/addon
COPY config/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

EXPOSE 80/tcp 443/tcp

STOPSIGNAL SIGQUIT
ENTRYPOINT ["/entrypoint.sh"]
CMD ["openresty", "-g", "daemon off;"]
