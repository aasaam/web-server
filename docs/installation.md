# Installation

Before installation you require the linux that install `docker.com` and `docker-compose`.

## Path

There are list of required path are must mounted from container to host.

| Container path                                               | Description                                                                 |
| ------------------------------------------------------------ | --------------------------------------------------------------------------- |
| `/usr/local/openresty/nginx/addon`                           | Path of webserver configuration files                                       |
| `/cache`                                                     | Path of cache files including proxy_cache and `pagespeed FileCachePath`     |
| `/log`                                                       | Path of log data including `error_log`, `access_log` and `pagespeed LogDir` |
| `/usr/local/openresty/nginx/defaults/selfsigned/dhparam.pem` | Path of _Diffie-Hellman parameters_                                         |
| `/usr/local/openresty/htpasswd/monitoring.htpasswd`          | Path of HTTP basic auth for monitoring                                      |

## Diffie-Hellman parameters

Generate dhparam, if you have multiple node sync them cross across all nodes.

```bash
openssl dhparam -out tmp/dhparam.pem 2048
```

## Monitoring basic auth

Generate monitoring htpasswd, replace `[user]` and `[password]` with your secure/specified credential.

```bash
printf "[user]:$(openssl passwd -apr1 [password])\n" > tmp/monitoring.htpasswd
```

## Log rotation

For prevent fill your storage via log files you must config the [logrotate](https://linux.die.net/man/8/logrotate) with your special log path in host.

If you mount `/log` to `/tmp/aasaam-web-server/log` then add logrotate config such as following example:

```txt
# /etc/logrotate.d/aasaam-web-server
/tmp/aasaam-web-server/log/nginx.in.*.log {
  hourly
  missingok
  rotate 4
  su root root
  notifempty
  nomail
  sharedscripts
  postrotate
    docker exec -it aasaam-web-server openresty -s reopen
  endscript
}
```

### Nginx (Error)Log Parser

For production better to use [nginx-error-log-parser](https://github.com/aasaam/nginx-error-log-parser) and use [nginx syslog](http://nginx.org/en/docs/syslog.html).

## Configuration

You can use [.env](https://docs.docker.com/compose/env-file/) file that docker-compose use it and inject to container.

| Name | Default | Description |
| --- | --- | --- |
| ⚙️ **aasaam/web-server** | | |
| ASM_SUPPORT_EMAIL |  | Support email address (e.g. `support@example.tld`) |
| ASM_SUPPORT_TEL |  | Support telephone (e.g. `+982100000000`) |
| ASM_SUPPORT_URL |  | Support URL (e.g. `http://support.example.tld`) |
| ASM_LOG_METHOD | `file` | Log method could be `file` or `syslog` otherwise will be docker /dev/stdout |
| ASM_NODE_ID | `0` | Node Identifier for scaling and monitoring |
| ASM_ORGANIZATION_TITLE | `aasaam software development group` | English title of organization that deployed web server |
| ASM_ORGANIZATION_BRAND_ICON | `ir_aasaam` | Brand Icon file name without `.svg` [aasaam Brand Icons](https://aasaam.github.io/brand-icons/) |
| ASM_CACHE_SIZE_MB | `1024` | Total path `/cache` size |
| ASM_HTTP_PORTS | `80` | Comma separated all exposed ports for HTTP, eg: `80` or `80,8080`. This will generate for you default hosts |
| ASM_HTTPS_PORTS | `443` | Comma separated all exposed ports for HTTPS, eg: `443` or `443,8443`. This will generate for you default hosts with self sign |
| ASM_SSL_PROFILE | `intermediate` | TLS profile could be `modern`, `intermediate` or `legacy`. One profile for each node deployment |
| ⚙️ **nginx_module_sts** | | |
| ASM_SERVER_TRAFFIC_STATUS_ZONE | `16m` | [server_traffic_status_zone](https://github.com/vozlt/nginx-module-sts#server_traffic_status_zone) |
| ⚙️ **nginx_module_vts** | | |
| ASM_VHOST_TRAFFIC_STATUS | `16m` | [vhost_traffic_status_zone](https://github.com/vozlt/nginx-module-vts#vhost_traffic_status_zone) |
| ⚙️ **ngx_brotli** | | |
| ASM_BROTLI | `on` | [brotli](https://github.com/google/ngx_brotli#brotli) |
| ASM_BROTLI_STATIC | `on` | [brotli_static](https://github.com/google/ngx_brotli#brotli_static) |
| ASM_BROTLI_COMP_LEVEL | `6` | [brotli_comp_level](https://github.com/google/ngx_brotli#brotli_comp_level) |
| ASM_BROTLI_MIN_LENGTH | `16` | [brotli_min_length](https://github.com/google/ngx_brotli#brotli_min_length) |
| ⚙️ **ngx_core_module** | | |
| ASM_WORKER_PROCESSES | `auto` | [worker_processes](http://nginx.org/en/docs/ngx_core_module.html#worker_processes) |
| ASM_WORKER_RLIMIT_NOFILE | `20480` | [worker_rlimit_nofile](http://nginx.org/en/docs/ngx_core_module.html#worker_rlimit_nofile) |
| ASM_WORKER_PRIORITY | `0` | [worker_priority](http://nginx.org/en/docs/ngx_core_module.html#worker_priority) |
| ASM_THREAD_POOL_THREADS | `32` | [thread_pool](http://nginx.org/en/docs/ngx_core_module.html#thread_pool) |
| ASM_THREAD_POOL_MAX_QUEUE | `65536` | [thread_pool](http://nginx.org/en/docs/ngx_core_module.html#thread_pool) |
| ASM_WORKER_CONNECTIONS | `8192` | [worker_connections](http://nginx.org/en/docs/ngx_core_module.html#worker_connections) |
| ASM_ACCEPT_MUTEX_DELAY | `500ms` | [accept_mutex_delay](http://nginx.org/en/docs/ngx_core_module.html#accept_mutex_delay) |
| ASM_ACCEPT_MUTEX | `off` | [accept_mutex](http://nginx.org/en/docs/ngx_core_module.html#accept_mutex) |
| ASM_MULTI_ACCEPT | `on` | [multi_accept](http://nginx.org/en/docs/ngx_core_module.html#multi_accept) |
| ASM_ERROR_LOG_SYSLOG_SERVER_ADDR | `127.0.0.1:5140` | Syslog server that listen UDP **RFC 3164**; [Nginx Logging to syslog](http://nginx.org/en/docs/syslog.html), [error_log](https://nginx.org/en/docs/ngx_core_module.html#error_log) |
| ASM_ACCESS_LOG_SYSLOG_SERVER_ADDR | `127.0.0.1:5141` | Syslog server that listen UDP **RFC 3164**; [Nginx Logging to syslog](http://nginx.org/en/docs/syslog.html), [error_log](https://nginx.org/en/docs/ngx_core_module.html#error_log) |
| ASM_ERROR_LOG_LEVEL | `warn` | Can be one of the following: `debug`, `info`, `notice`, `warn`, `error`, `crit`, `alert` or `emerg`, [error_log](https://nginx.org/en/docs/ngx_core_module.html#error_log) |
| ⚙️ **ngx_http_core_module** | | |
| ASM_RESOLVER_ADDR | `127.0.0.1` | [resolver](http://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) |
| ASM_RESOLVER_VALID | `10m` | [resolver](http://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) |
| ASM_RESOLVER_TIMEOUT | `30s` | [resolver_timeout](http://nginx.org/en/docs/http/ngx_http_core_module.html#resolver_timeout) |
| ASM_VARIABLES_HASH_MAX_SIZE | `4096` | [variables_hash_max_size](http://nginx.org/en/docs/http/ngx_http_core_module.html#variables_hash_max_size) |
| ASM_OPEN_FILE_CACHE_MAX | `1024` | [open_file_cache](http://nginx.org/en/docs/http/ngx_http_core_module.html#open_file_cache) |
| ASM_OPEN_FILE_CACHE_INACTIVE | `10m` | [open_file_cache](http://nginx.org/en/docs/http/ngx_http_core_module.html#open_file_cache) |
| ASM_OPEN_FILE_CACHE_VALID | `5m` | [open_file_cache_valid](http://nginx.org/en/docs/http/ngx_http_core_module.html#open_file_cache_valid) |
| ASM_OPEN_FILE_CACHE_MIN_USES | `2` | [open_file_cache_min_uses](http://nginx.org/en/docs/http/ngx_http_core_module.html#open_file_cache_min_uses) |
| ASM_OPEN_FILE_CACHE_ERRORS | `on` | [open_file_cache_errors](http://nginx.org/en/docs/http/ngx_http_core_module.html#open_file_cache_errors) |
| ASM_SERVER_TOKENS | `off` | [server_tokens](http://nginx.org/en/docs/http/ngx_http_core_module.html#server_tokens) |
| ASM_CLIENT_MAX_BODY_SIZE | `10M` | [client_max_body_size](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size) |
| ASM_CLIENT_BODY_TIMEOUT | `15` | [client_body_timeout](http://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_timeout) |
| ASM_KEEPALIVE_REQUESTS | `1024` | [keepalive_requests](http://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_requests) |
| ASM_KEEPALIVE_TIMEOUT | `10` | [keepalive_timeout](http://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_timeout) |
| ASM_RESET_TIMEDOUT_CONNECTION | `on` | [reset_timedout_connection](http://nginx.org/en/docs/http/ngx_http_core_module.html#reset_timedout_connection) |
| ASM_SEND_TIMEOUT | `10` | [send_timeout](http://nginx.org/en/docs/http/ngx_http_core_module.html#send_timeout) |
| ASM_SENDFILE | `on` | [sendfile](http://nginx.org/en/docs/http/ngx_http_core_module.html#sendfile) |
| ASM_TCP_NODELAY | `on` | [tcp_nodelay](http://nginx.org/en/docs/http/ngx_http_core_module.html#tcp_nodelay) |
| ASM_TCP_NOPUSH | `on` | [tcp_nopush](http://nginx.org/en/docs/http/ngx_http_core_module.html#tcp_nopush) |
| ⚙️ **ngx_http_gzip_module** | | |
| ASM_GZIP | `on` | [gzip](http://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip) |
| ASM_GZIP_MIN_LENGTH | `16` | [gzip_min_length](http://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_min_length) |
| ASM_GZIP_COMP_LEVEL | `6` | [gzip_comp_level](http://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_comp_level) |
| ASM_GZIP_VARY | `on` | [gzip_vary](http://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_vary) |
| ASM_GZIP_PROXIED | `any` | [gzip_proxied](http://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_proxied) |
| ⚙️ **ngx_http_gzip_static_module** | | |
| ASM_GZIP_STATIC | `on` | [gzip_static](http://nginx.org/en/docs/http/ngx_http_gzip_static_module.html#gzip_static) |
| ⚙️ **ngx_http_limit_conn_module** | | |
| ASM_PROTECTION_CONN_LIMIT_PER_IP_ZONE | `10m` | [limit_conn_zone](http://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_conn_zone) |
| ⚙️ **ngx_http_limit_req_module** | | |
| ASM_PROTECTION_REQ_LIMIT_PER_IP_ZONE | `10m` | [limit_req_zone](http://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_zone) |
| ASM_PROTECTION_REQ_LIMIT_IP_PER_SECOND | `10` | [limit_req_zone](http://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_zone) |
| ⚙️ **ngx_http_proxy_module** | | |
| ASM_PROXY_CACHE_PATH_KEYS_ZONE | `32m` | [proxy_cache_path](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path) |
| ASM_PROXY_CACHE_PATH_KEYS_MAX_SIZE_MB | `512` | [proxy_cache_path](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path) |
| ASM_PROXY_CACHE_PATH_KEYS_INACTIVE | `60m` | [proxy_cache_path](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path) |
| ASM_PROXY_CACHE_KEY | `$scheme$request_method$host$request_uri` | [proxy_cache_key](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_key) |
| ASM_PROXY_CACHE_METHODS | `GET HEAD` | [proxy_cache_methods](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_methods) |
| ASM_PROXY_BUFFERS | `32` | [proxy_buffers](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffers) |
| ASM_PROXY_BUFFERS_SIZE | `128k` | [proxy_buffer_size](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffer_size) |
| ASM_PROXY_BUFFER_SIZE | `256k` | [proxy_buffers](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffers) |
| ⚙️ **ngx_http_userid_module** | | |
| ASM_USERID_NAME | `aasaam_cid` | [userid_name](http://nginx.org/en/docs/http/ngx_http_userid_module.html#userid_name) |
| ASM_USERID_PATH | `/` | [userid_path](http://nginx.org/en/docs/http/ngx_http_userid_module.html#userid_path) |
| ASM_USERID_FLAGS | `httponly samesite=lax` | [userid_flags](http://nginx.org/en/docs/http/ngx_http_userid_module.html#userid_flags) |
| ASM_USERID_EXPIRES | `365d` | [userid_expires](http://nginx.org/en/docs/http/ngx_http_userid_module.html#userid_expires) |
| ⚙️ **ngx_http_v2_module** | | |
| ASM_HTTP2_PUSH_PRELOAD | `on` | [http2_push_preload](http://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_push_preload) |
| ⚙️ **ngx_pagespeed** | | |
| ASM_PAGESPEED | `standby` | [Setting the module on](https://www.modpagespeed.com/doc/configuration#on) |
| ASM_PAGESPEED_USE_PER_VHOST_STATISTICS | `on` | [Virtual hosts and statistics](https://www.modpagespeed.com/doc/admin#virtual-hosts-and-stats) |
| ASM_PAGESPEED_HTTP_CACHE_COMPRESSION_LEVEL | `0` | [Configuring HTTPCache Compression for PageSpeed](https://www.modpagespeed.com/doc/system#gzip_cache) |
| ASM_PAGESPEED_FETCH_WITH_GZIP | `on` | [Fetching Resources using Gzip](https://www.modpagespeed.com/doc/system#fetch_with_gzip) |
| ASM_PAGESPEED_STATISTICS | `on` | [Shared Memory Statistics](https://www.modpagespeed.com/doc/system#fetch_with_gzip) |
| ASM_PAGESPEED_STATISTICS_LOGGING | `off` | [StatisticsLogging](https://www.modpagespeed.com/doc/console#configuring) |
| ASM_PAGESPEED_STATISTICS_LOGGING_INTERVAL_MS | `60000` | [StatisticsLoggingIntervalMs](https://www.modpagespeed.com/doc/console#configuring) |
| ASM_PAGESPEED_STATISTICS_LOGGING_MAX_FILE_SIZE_KB | `8192` | [StatisticsLoggingMaxFileSizeKb](https://www.modpagespeed.com/doc/console#configuring) |
| ASM_PAGESPEED_MESSAGE_BUFFER_SIZE | `100000` | [Message Buffer Size](https://www.modpagespeed.com/doc/admin#message-buffer-size) |
| ASM_PAGESPEED_FILE_CACHE_SIZE_KB | `102400` | [Configuring the File Cache](https://www.modpagespeed.com/doc/system#file_cache) |
| ASM_PAGESPEED_FILE_CACHE_CLEAN_INTERVAL_MS | `600000` | [Configuring the File Cache](https://www.modpagespeed.com/doc/system#file_cache) |
| ASM_PAGESPEED_FILE_CACHE_INODE_LIMIT | `262144` | [Configuring the File Cache](https://www.modpagespeed.com/doc/system#file_cache) |
| ASM_PAGESPEED_LRU_CACHE_KB_PER_PROCESS | `2048` | [Configuring the in-memory LRU Cache](https://www.modpagespeed.com/doc/system#lru_cache) |
| ASM_PAGESPEED_LRU_CACHE_BYTE_LIMIT | `32768` | [Configuring the in-memory LRU Cache](https://www.modpagespeed.com/doc/system#lru_cache) |
