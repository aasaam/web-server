FROM ubuntu:focal AS builder

LABEL org.label-schema.name="web-server" \
      org.label-schema.description="web-server" \
      org.label-schema.url=https://github.com/aasaam/web-server \
      org.label-schema.vendor="aasaam" \
      maintainer="Muhammad Hussein Fattahizadeh <m@mhf.ir>"

ADD tools/patch-source.py /tmp/patch-source.py
RUN export DEBIAN_FRONTEND=noninteractive ; \
  export LANG=en_US.utf8 ; \
  export LC_ALL=C.UTF-8 ; \
  apt-get update -y \
  && apt-get -y upgrade \
  && apt-get install --no-install-recommends -y gnupg \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F44B38CE3DB1BF64B61DBD28DE1997DCDE742AFA \
  && echo 'deb http://ppa.launchpad.net/maxmind/ppa/ubuntu focal main' > /etc/apt/sources.list.d/maxmind.list \
  && apt-get update -y \
  && apt-get install -y build-essential bzr-builddeb ca-certificates curl dh-make dh-systemd gnupg gnupg2 jq \
    libmaxminddb0 libmaxminddb-dev mmdb-bin libpcre3 libpcre3-dev libtemplate-perl lsb-release make perl python sudo systemtap-sdt-dev unzip uuid-dev wget zlib1g-dev \
  ## python patch
  && cd /tmp \
  && chmod +x /tmp/patch-source.py \
  ## nchan
  && cd /tmp \
  && wget https://github.com/slact/nchan/archive/v1.2.7.tar.gz -O nchan.tgz \
  && tar -xf nchan.tgz \
  && export NGINX_MODULE_NCHAN=`realpath nchan-1.*/` \
  ## naxsi
  && cd /tmp \
  && wget https://github.com/nbs-system/naxsi/archive/1.2.tar.gz -O naxsi.tgz \
  && tar -xf naxsi.tgz \
  && export NGINX_MODULE_NAXI=`realpath naxsi-1.*/naxsi_src` \
  ## nginx-vod-module
  && cd /tmp \
  && wget https://github.com/kaltura/nginx-vod-module/archive/1.27.tar.gz -O nginx-vod-module.tgz \
  && tar -xf nginx-vod-module.tgz \
  && export NGINX_MODULE_VOD=`realpath nginx-vod-module-1*` \
  ## page speed
  && cd /tmp \
  && export NPS_VERSION=1.13.35.2-stable \
  && wget -c https://github.com/apache/incubator-pagespeed-ngx/archive/v${NPS_VERSION}.zip \
  && unzip v${NPS_VERSION}.zip \
  && export nps_dir=`realpath *pagespeed-ngx*` \
  && cd $nps_dir \
  && export NPS_RELEASE_NUMBER=$NPS_VERSION/beta/ \
  && export NPS_RELEASE_NUMBER=$NPS_VERSION/stable/ \
  && export psol_url="https://dl.google.com/dl/page-speed/psol/$NPS_RELEASE_NUMBER.tar.gz" \
  && ls -laF scripts/ \
  && [ -e scripts/format_binary_url.sh ] && psol_url=$(scripts/format_binary_url.sh PSOL_BINARY_URL) \
  && wget -c ${psol_url} \
  && tar -xzvf $(basename ${psol_url}) \
  && export NGINX_MODULE_PS=`realpath "$nps_dir"` \
  ## geoip2
  && cd /tmp \
  && wget -O ngx_http_geoip2_module.tgz https://github.com/leev/ngx_http_geoip2_module/archive/3.3.tar.gz \
  && tar -xf ngx_http_geoip2_module.tgz \
  && export NGINX_MODULE_GEOIP2=`realpath /tmp/ngx_http_geoip2_module-*` \
  ## brotli
  && cd /tmp \
  && git clone https://github.com/google/ngx_brotli /tmp/ngx_brotli \
  && cd /tmp/ngx_brotli \
  && git submodule update --init \
  && export NGINX_MODULE_BROTLI=`realpath /tmp/ngx_brotl*` \
  ## nginx-module-sts
  && cd /tmp \
  && git clone https://github.com/vozlt/nginx-module-sts /tmp/nginx-module-sts \
  && export NGINX_MODULE_STS=`realpath /tmp/nginx-module-sts` \
  ## nginx-module-stream-sts
  && cd /tmp \
  && git clone https://github.com/vozlt/nginx-module-stream-sts /tmp/nginx-module-stream-sts \
  && export NGINX_MODULE_STREAM_STS=`realpath /tmp/nginx-module-stream-sts` \
  ## nginx-module-vts
  && cd /tmp \
  && git clone https://github.com/vozlt/nginx-module-vts /tmp/nginx-module-vts \
  && export NGINX_MODULE_VTS=`realpath /tmp/nginx-module-vts` \
  ## openresty download
  && cd /tmp \
  && wget -O openresty.tgz https://github.com/openresty/openresty-packaging/archive/master.tar.gz \
  && tar -xf openresty.tgz \
  && rm -rf /tmp/builder/resty \
  && mkdir -p /tmp/builder/resty \
  ## openresty
  && cd /tmp/openresty-packaging-master/deb \
  && grep -v "debsigs" Makefile > temp && cat temp > Makefile \
  && sed -i 's#OPTS=#OPTS=-b -uc -us#g' Makefile \
  && sed -i 's#tar xf openresty_$(OR_VER).orig.tar.gz --strip-components=1 -C openresty#tar xf openresty_$(OR_VER).orig.tar.gz --strip-components=1 -C openresty \&\& /tmp/patch-source.py `realpath openresty/bundle/nginx-1*/` #g' Makefile \
  && sed -i "s#--with-threads#--with-threads --with-ld-opt=\"-Wl,-rpath,$PHP_LIB\" --add-module=$NGINX_MODULE_NCHAN --add-module=$NGINX_MODULE_STS --add-module=$NGINX_MODULE_STREAM_STS --add-module=$NGINX_MODULE_VTS --add-module=$NGINX_MODULE_BROTLI --add-module=$NGINX_MODULE_NAXI --add-module=$NGINX_MODULE_PS --add-module=$NGINX_MODULE_GEOIP2#g" openresty/debian/rules \
  && make zlib-build \
  && export DEB_TO_INSTALL=`realpath openresty-zlib_1.*.deb` \
  && export DEB_DEV_TO_INSTALL=`realpath openresty-zlib-dev_1.*.deb` \
  && cp $DEB_TO_INSTALL /tmp/builder/openresty-zlib.deb \
  && cp $DEB_DEV_TO_INSTALL /tmp/builder/openresty-zlib-dev.deb \
  && dpkg -i /tmp/builder/openresty-zlib.deb \
  && dpkg -i /tmp/builder/openresty-zlib-dev.deb \
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
  && export DEB_TO_INSTALL=`realpath openresty_1*focal1_amd64.deb` \
  && cp $DEB_TO_INSTALL /tmp/builder/openresty.deb \
  && export DEB_TO_INSTALL=`realpath openresty-resty_1*focal1_all.deb` \
  && cp $DEB_TO_INSTALL /tmp/builder/openresty-resty.deb \
  && export DEB_TO_INSTALL=`realpath openresty-opm_1*focal1_amd64.deb` \
  && cp $DEB_TO_INSTALL /tmp/builder/openresty-opm.deb \
  && cd /tmp \
  && wget -O error-pages.tgz https://github.com/aasaam/error-pages/archive/master.tar.gz \
  && tar -xf error-pages.tgz \
  && cd /tmp/error-pages-master/dist/nginx \
  && rm -rf /tmp/builder/error-pages \
  && mv error-pages /tmp/builder/ \
  && cd /tmp \
  && wget -O /tmp/icons.tgz https://github.com/aasaam/brand-icons/archive/master.tar.gz \
  && tar -xf /tmp/icons.tgz \
  && mv brand-icons-master/svg /tmp/builder/error-pages/ \
  && wget -O dl_woothee.tgz https://github.com/woothee/lua-resty-woothee/archive/v1.11.0-1.tar.gz \
  && tar -xf dl_woothee.tgz \
  && export WOOTHEE_PATH=`realpath /tmp/lua-resty-woothee-1*/lib` \
  && cd $WOOTHEE_PATH \
  && cp -rf resty/* /tmp/builder/resty/ \
  && cd /tmp \
  && wget -O lua_resty_url.tgz https://github.com/3scale/lua-resty-url/archive/v0.3.5.tar.gz \
  && tar -xf lua_resty_url.tgz \
  && export LUA_RESTY_URL_PATH=`realpath /tmp/lua-resty-url*/src/` \
  && cd $LUA_RESTY_URL_PATH \
  && cp -rf resty/* /tmp/builder/resty/ \
  && cd /tmp/builder \
  && export SENTRY_VERSION=$(curl -s https://api.github.com/repos/getsentry/sentry-javascript/releases/latest | jq -r '.assets[].browser_download_url' | grep sentry-browser | grep -o -P '(?<=download\/).*(?=\/)') \
  && export SENTRY_URL="https://browser.sentry-cdn.com/$SENTRY_VERSION/bundle.min.js" \
  && wget -O /tmp/builder/sentry.js $SENTRY_URL \
  && wget -O /tmp/builder/nchan.js 'https://cdn.jsdelivr.net/gh/slact/nchan.js/NchanSubscriber.min.js' \
  && sed -i '/sourceMappingURL/d' /tmp/builder/sentry.js \
  && sed -i '/sourceMappingURL/d' /tmp/builder/nchan.js \
  && wget -O /tmp/builder/favicon.ico https://raw.githubusercontent.com/aasaam/information/master/logo/icons/favicon.ico \
  && wget -O /tmp/builder/humans.txt https://raw.githubusercontent.com/aasaam/information/master/info/humans.txt \
  && cd /tmp \
  && tar -czf builder.tgz builder

FROM ubuntu:focal

COPY --from=builder /tmp/builder.tgz /tmp/builder.tgz
RUN export DEBIAN_FRONTEND=noninteractive ; \
  export LANG=en_US.utf8 ; \
  export LC_ALL=C.UTF-8 ; \
  apt-get update -y \
  && apt-get -y upgrade \
  && apt-get install --no-install-recommends -y gnupg \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F44B38CE3DB1BF64B61DBD28DE1997DCDE742AFA \
  && echo 'deb http://ppa.launchpad.net/maxmind/ppa/ubuntu focal main' > /etc/apt/sources.list.d/maxmind.list \
  && apt-get update -y \
  && apt-get install --no-install-recommends -y libmaxminddb0 perl libfile-spec-perl libtime-hires-perl curl ca-certificates wget build-essential \
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
  && $OPENSSL_BIN dhparam -out /usr/local/openresty/nginx/dhparams.pem 2048 \
  && cp /tmp/builder/favicon.ico /usr/local/openresty/nginx/favicon.ico \
  && cp /tmp/builder/humans.txt /usr/local/openresty/nginx/humans.txt \
  && cp /tmp/builder/sentry.js /usr/local/openresty/nginx/sentry.js \
  && cp /tmp/builder/nchan.js /usr/local/openresty/nginx/nchan.js \
  # luarocks
  && cd /tmp/ \
  && wget https://luarocks.github.io/luarocks/releases/luarocks-3.4.0.tar.gz -O luarocks.tgz \
  && tar -xf luarocks.tgz \
  && cd luarocks-3* \
  && ./configure --prefix=/usr/local/openresty/luajit \
    --with-lua=/usr/local/openresty/luajit/ \
    --lua-suffix=jit \
    --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 \
  && make && make install \
  && sudo /usr/local/openresty/luajit/luarocks install lua-resty-ntlm \
  && sudo /usr/local/openresty/luajit/luarocks install lua-http-parser \
  && echo "======== VERSION ==========" \
  && /usr/bin/openresty -V 2>&1 | tee /tmp/VERSION \
  && cat /tmp/VERSION \
  && echo "======== /VERSION ==========" \
  && apt-get purge wget build-essential \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /usr/share/doc \
  && rm -rf /usr/share/man \
  && rm -rf /usr/share/locale \
  && rm -rf /root/.op* \
  && rm -r /var/lib/apt/lists/* && rm -rf /tmp && mkdir /tmp && chmod 777 /tmp && truncate -s 0 /var/log/*.log \
  && find /usr/local/openresty/nginx/error-pages -type f -print0 | xargs -0 chmod 0644 \
  && find /usr/local/openresty/lualib -type d -print0 | xargs -0 chmod 0755 \
  && find /usr/local/openresty/lualib -type f -print0 | xargs -0 chmod 0644

# defaults config
COPY config/defaults /usr/local/openresty/nginx/defaults
COPY config/security.txt /usr/local/openresty/nginx/security.txt
COPY config/robots.txt /usr/local/openresty/nginx/robots.txt

# lua scripts
COPY config/lua/access_normal.lua /usr/local/openresty/lualib/access_normal.lua
COPY config/lua/normalize.lua /usr/local/openresty/lualib/normalize.lua
COPY config/lua/locales.lua /usr/local/openresty/lualib/locales.lua
COPY config/lua/browsers.lua /usr/local/openresty/lualib/browsers.lua
COPY config/lua/utils.lua /usr/local/openresty/lualib/utils.lua

# nginx.conf
COPY addon /usr/local/openresty/nginx/addon
COPY config/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

EXPOSE 80/tcp 443/tcp

STOPSIGNAL SIGTERM
CMD ["openresty", "-g", "daemon off;"]
