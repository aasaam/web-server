# Installation

Before installation you require the linux that install `docker.com` and `docker-compose`.

## dhparam

Generate dhparam, if you have multiple node sync them cross across all nodes.

```bash
openssl dhparam -out tmp/dhparam.pem 2048
```

## Configuration

You can use [.env](https://docs.docker.com/compose/env-file/) file that docker-compose use it and inject to container.

| Name                                   | Default                                   |
| -------------------------------------- | ----------------------------------------- |
| ASM_ACCEPT_MUTEX | `off` |
| ASM_ACCEPT_MUTEX_DELAY | `500ms` |
| ASM_BROTLI | `on` |
| ASM_BROTLI_COMP_LEVEL | `6` |
| ASM_BROTLI_MIN_LENGTH | `16` |
| ASM_BROTLI_STATIC | `on` |
| ASM_CACHE_SIZE_MB | `1024` |
| ASM_CLIENT_BODY_TIMEOUT | `15` |
| ASM_CLIENT_MAX_BODY_SIZE | `10M` |
| ASM_GZIP | `on` |
| ASM_GZIP_COMP_LEVEL | `6` |
| ASM_GZIP_MIN_LENGTH | `16` |
| ASM_GZIP_PROXIED | `any` |
| ASM_GZIP_STATIC | `on` |
| ASM_GZIP_VARY | `on` |
| ASM_HTTP2_PUSH_PRELOAD | `on` |
| ASM_HTTPS_PORTS | `443` |
| ASM_HTTP_PORTS | `80` |
| ASM_KEEPALIVE_REQUESTS | `1024` |
| ASM_KEEPALIVE_TIMEOUT | `10` |
| ASM_LOG_METHOD | `syslog` |
| ASM_LOG_SYSLOG_SERVER_ADDR | `127.0.0.1:5140` |
| ASM_MAIN_LOG_LEVEL | `warn` |
| ASM_NODE_ID | `0` |
| ASM_OPEN_FILE_CACHE_ERRORS | `on` |
| ASM_OPEN_FILE_CACHE_INACTIVE | `10m` |
| ASM_OPEN_FILE_CACHE_MAX | `1024` |
| ASM_OPEN_FILE_CACHE_MIN_USES | `2` |
| ASM_OPEN_FILE_CACHE_VALID | `5m` |
| ASM_ORGANIZATION_BRAND_ICON | `ir_aasaam` |
| ASM_ORGANIZATION_TITLE | `aasaam software development group` |
| ASM_PAGESPEED | `standby` |
| ASM_PAGESPEED_FETCH_WITH_GZIP | `on` |
| ASM_PAGESPEED_FILE_CACHE_CLEAN_INTERVAL_MS | `600000` |
| ASM_PAGESPEED_FILE_CACHE_INODE_LIMIT | `262144` |
| ASM_PAGESPEED_FILE_CACHE_SIZE_KB | `102400` |
| ASM_PAGESPEED_HTTP_CACHE_COMPRESSION_LEVEL | `0` |
| ASM_PAGESPEED_LRU_CACHE_BYTE_LIMIT | `32768` |
| ASM_PAGESPEED_LRU_CACHE_KB_PER_PROCESS | `2048` |
| ASM_PAGESPEED_MESSAGE_BUFFER_SIZE | `100000` |
| ASM_PAGESPEED_STATISTICS | `on` |
| ASM_PAGESPEED_STATISTICS_LOGGING | `off` |
| ASM_PAGESPEED_STATISTICS_LOGGING_INTERVAL_MS | `60000` |
| ASM_PAGESPEED_STATISTICS_LOGGING_MAX_FILE_SIZE_KB | `8192` |
| ASM_PAGESPEED_USE_PER_VHOST_STATISTICS | `on` |
| ASM_PROTECTION_CONN_LIMIT_PER_IP_ZONE | `10m` |
| ASM_PROTECTION_REQ_LIMIT_IP_PER_SECOND | `10` |
| ASM_PROTECTION_REQ_LIMIT_PER_IP_ZONE | `10m` |
| ASM_PROXY_BUFFERS | `32` |
| ASM_PROXY_BUFFERS_SIZE | `128k` |
| ASM_PROXY_BUFFER_SIZE | `256k` |
| ASM_PROXY_CACHE_KEY | `$scheme$request_method$host$request_uri` |
| ASM_PROXY_CACHE_METHODS | `GET HEAD` |
| ASM_PROXY_CACHE_PATH_KEYS_INACTIVE | `60m` |
| ASM_PROXY_CACHE_PATH_KEYS_MAX_SIZE_MB | `512` |
| ASM_PROXY_CACHE_PATH_KEYS_ZONE | `32m` |
| ASM_RESET_TIMEDOUT_CONNECTION | `on` |
| ASM_RESOLVER_ADDR | `127.0.0.1` |
| ASM_RESOLVER_TIMEOUT | `30s` |
| ASM_RESOLVER_VALID | `10m` |
| ASM_SENDFILE | `on` |
| ASM_SEND_TIMEOUT | `10` |
| ASM_SERVER_TOKENS | `off` |
| ASM_SERVER_TRAFFIC_STATUS_ZONE | `16m` |
| ASM_SSL_PROFILE | `intermediate` |
| ASM_TCP_NODELAY | `on` |
| ASM_TCP_NOPUSH | `on` |
| ASM_THREAD_POOL_MAX_QUEUE | `65536` |
| ASM_THREAD_POOL_THREADS | `32` |
| ASM_USERID_EXPIRES | `365d` |
| ASM_USERID_FLAGS | `httponly samesite=lax` |
| ASM_USERID_NAME | `aasaam_cid` |
| ASM_USERID_PATH | `/` |
| ASM_VARIABLES_HASH_MAX_SIZE | `4096` |
| ASM_VHOST_TRAFFIC_STATUS | `16m` |
| ASM_WORKER_CONNECTIONS | `8192` |
| ASM_WORKER_PRIORITY | `0` |
| ASM_WORKER_PROCESSES | `auto` |
| ASM_WORKER_RLIMIT_NOFILE | `20480` |
