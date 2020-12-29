#!/bin/bash
set -e

# define variables
DEFINED_ENVS=$(printf '${%s} ' $(env | cut -d= -f1))

ADDON_TEMPLATE_PATH=/usr/local/openresty/nginx/addon/templates
ADDON_OUTPUT=/usr/local/openresty/addon-generated
NGINX_DOT_CONF_PATH=/usr/local/openresty/nginx/conf/nginx.conf

NGINX_DOT_CONF_TEMPLATE=$ADDON_TEMPLATE_PATH/nginx.conf
ADDON_TEMPLATES=$(find $ADDON_TEMPLATE_PATH -type f -name "*.nginx.conf")
# GOMPLATE_TEMPLATES=$(find $ADDON_TEMPLATE_PATH -type f -name "*.nginx.tmpl")

if [ -f "$NGINX_DOT_CONF_TEMPLATE" ]; then
  echo "Using template for $NGINX_DOT_CONF_PATH"
  envsubst "$DEFINED_ENVS" < "$NGINX_DOT_CONF_TEMPLATE" > $NGINX_DOT_CONF_PATH
fi

if [[ ! -z "$ADDON_TEMPLATES" ]]; then
  for T_PATH in $ADDON_TEMPLATES; do
    T_NAME=$(basename -- $T_PATH)
    T_OUT=$ADDON_OUTPUT/$T_NAME
    envsubst "$DEFINED_ENVS" < "$T_PATH" > "$T_OUT"
    echo "New addon generate on $T_OUT"
  done
fi

# if [[ ! -z "$GOMPLATE_TEMPLATES" ]]; then
#   for T_PATH in $GOMPLATE_TEMPLATES; do
#     T_NAME=$(basename -- $T_PATH)
#     T_NAME=${T_NAME/tmpl/conf}
#     T_OUT=$ADDON_OUTPUT/$T_NAME
#     envsubst "$DEFINED_ENVS" < "$T_PATH" > "$T_OUT"
#     echo "New addon generate on $T_OUT"
#   done
# fi

exec "$@"
