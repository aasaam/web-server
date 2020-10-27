# web server

[![aasaam](https://flat.badgen.net/badge/aasaam/software%20development%20group/0277bd?labelColor=000000&icon=https%3A%2F%2Fcdn.jsdelivr.net%2Fgh%2Faasaam%2Finformation%2Flogo%2Faasaam.svg)](https://github.com/aasaam)

[![docker-image-size](https://flat.badgen.net/docker/size/aasaam/web-server)](https://hub.docker.com/r/aasaam/web-server)
[![docker-repository-on-quay](https://flat.badgen.net/badge/quay.io/repo/cyan)](https://quay.io/repository/aasaam/web-server)

[![open-issues](https://flat.badgen.net/github/open-issues/aasaam/web-server)](https://github.com/aasaam/web-server/issues)
[![open-pull-requests](https://flat.badgen.net/github/open-prs/aasaam/web-server)](https://github.com/aasaam/web-server/pulls)

Improved [Nginx](http://nginx.org/)/[OpenResty](https://openresty.org/en/) via:

* [incubator-pagespeed-ngx](https://github.com/apache/incubator-pagespeed-ngx)
* [naxsi](https://github.com/nbs-system/naxsi)
* [nchan](https://github.com/slact/nchan)
* [nginx-module-stream-sts](https://github.com/vozlt/nginx-module-stream-sts)
* [nginx-module-sts](https://github.com/vozlt/nginx-module-sts)
* [nginx-module-vts](https://github.com/vozlt/nginx-module-vts)
* [ngx_brotli](https://github.com/google/ngx_brotli)
* [ngx_http_geoip2_module](https://github.com/leev/ngx_http_geoip2_module)
* [woothee](http://woothee.github.io)
* [custom error pages](https://aasaam.github.io/error-pages)

## Requirement

* Mount `/cache`, `/log` and `/GeoIP2` and for store cache, logs and read MaxMind GeoIP2 data:
  * Main error log `/log/nginx.main.error.log`
  * HTTP error log `/log/nginx.http.error.log`
  * Access log `/log/nginx.access.ndjson`
  * PageSpeed log `/log/nginx-pagespeed`
  * Proxy cache `/cache/nginx-proxy`
  * FastCGI cache `/cache/nginx-fastcgi`
  * PageSpeed cache `/cache/nginx-pagespeed`
  * For MaxMind GeoIP2 data file `/GeoIP2/City.mmdb` and `/GeoIP2/ASN.mmdb` must be exist.

## Usage

You can use docker-compose for creating container.
