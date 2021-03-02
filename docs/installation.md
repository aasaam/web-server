# Installation

Before installation you require the linux that install docker and docker-compose.

## Configuration

| Name                                  | Default                                   |
| ------------------------------------- | ----------------------------------------- |
| ASM_NGINX_WORKER_PROCESSES            | `auto`                                    |
| ASM_NGINX_WORKER_RLIMIT_NOFILE        | `20480`                                   |
| ASM_NGINX_WORKER_CONNECTIONS          | `8192`                                    |
| ASM_LOG_METHOD                        | `syslog`                                  |
| ASM_NODE_ID                           | `0`                                       |
| ASM_LOG_SYSLOG_SERVER_ADDR            | `127.0.0.1:5140`                          |
| ASM_NGINX_MAIN_LOG_LEVEL              | `warn`                                    |
| ASM_RESOLVER_ADDR                     | `127.0.0.1`                               |
| ASM_VARIABLES_HASH_MAX_SIZE           | `4096`                                    |
| ASM_OPEN_FILE_CACHE_MAX               | `1024`                                    |
| ASM_OPEN_FILE_CACHE_VALID             | `5m`                                      |
| ASM_OPEN_FILE_CACHE_MIN_USES          | `2`                                       |
| ASM_OPEN_FILE_CACHE_ERRORS            | `on`                                      |
| ASM_ORGANIZATION_TITLE                | `aasaam software development group`       |
| ASM_ORGANIZATION_BRAND_ICON           | `ir_aasaam`                               |
| ASM_CLIENT_MAX_BODY_SIZE              | `10M`                                     |
| ASM_CLIENT_MAX_BODY_SIZE              | `10M`                                     |
| ASM_CLIENT_BODY_TIMEOUT               | `15`                                      |
| ASM_KEEPALIVE_REQUESTS                | `1024`                                    |
| ASM_KEEPALIVE_TIMEOUT                 | `10`                                      |
| ASM_SEND_TIMEOUT                      | `10`                                      |
| ASM_PROXY_CACHE_PATH_KEYS_ZONE        | `32m`                                     |
| ASM_PROXY_CACHE_KEY                   | `$scheme$request_method$host$request_uri` |
| ASM_PROXY_CACHE_METHODS               | `GET HEAD`                                |
| ASM_PROXY_BUFFERS                     | `32`                                      |
| ASM_PROXY_BUFFER_SIZE                 | `256k`                                    |
| ASM_PROTECTION_REQ_LIMIT_PER_IP_ZONE  | `10m`                                     |
| ASM_PROTECTION_CONN_LIMIT_PER_IP_ZONE | `10m`                                     |
| ASM_HTTP_PORTS                        | `80`                                      |
| ASM_HTTPS_PORTS                       | `443`                                     |
| ASM_SSL_PROFILE                       | `intermediate`                            |
| ASM_SERVER_TRAFFIC_STATUS_ZONE        | `16m`                                     |
