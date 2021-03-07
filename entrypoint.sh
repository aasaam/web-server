#!/bin/bash
# Copyright (c) 2021 aasaam software development group

set -e

# defined env variables
DEFINED_ENVS=$(printf '${%s} ' $(env | cut -d= -f1))

ADDON_TEMPLATE_PATH=/usr/local/openresty/nginx/addon/templates
ADDON_OUTPUT=/usr/local/openresty/addon-generated/sites-enabled
NGINX_DOT_CONF_PATH=/usr/local/openresty/nginx/conf/nginx.conf
GOMPLATE_PATH=/usr/local/openresty/nginx/addon/gomplates/sites-enabled

NGINX_DOT_CONF_TEMPLATE=$ADDON_TEMPLATE_PATH/nginx.conf
NGINX_DOT_CONF_GOMPLATE=/usr/local/openresty/nginx/addon/gomplates/nginx.tmpl
ADDON_TEMPLATES=$(find $ADDON_TEMPLATE_PATH -type f -name "*.nginx.conf")
GOMPLATE_TEMPLATES=$(find $GOMPLATE_PATH -type f -name "*.tmpl")
GOMPLATE_CONFIGS=$(find $GOMPLATE_PATH -type f -name "*.toml")

if [ -f "$NGINX_DOT_CONF_TEMPLATE" ]; then
  echo "Using template for $NGINX_DOT_CONF_PATH"
  envsubst "$DEFINED_ENVS" < "$NGINX_DOT_CONF_TEMPLATE" > $NGINX_DOT_CONF_PATH
fi

if [ -f "$NGINX_DOT_CONF_GOMPLATE" ]; then
  echo "Using gomplate for $NGINX_DOT_CONF_GOMPLATE"
  gomplate -f $NGINX_DOT_CONF_GOMPLATE > $NGINX_DOT_CONF_PATH
fi

if [[ ! -z "$ADDON_TEMPLATES" ]]; then
  for T_PATH in $ADDON_TEMPLATES; do
    T_NAME=$(basename -- $T_PATH)
    T_OUT=$ADDON_OUTPUT/$T_NAME
    envsubst "$DEFINED_ENVS" < "$T_PATH" > "$T_OUT"
    echo "New addon generate on $T_OUT"
  done
fi

if [[ ! -z "$GOMPLATE_TEMPLATES" ]]; then
  for T_PATH in $GOMPLATE_TEMPLATES; do
    T_CONFIG=${T_PATH/.tmpl/.toml}
    if [ -f "$T_CONFIG" ]; then
      T_NAME=$(basename -- $T_PATH)
      T_NGINX_OUT=${T_NAME/tmpl/conf}
      T_OUT=$ADDON_OUTPUT/$T_NGINX_OUT
      echo "# Generated on $(date)" > $T_OUT
      echo "# Template      : $T_PATH" >> $T_OUT
      echo "# Configuration : $T_CONFIG" >> $T_OUT
      gomplate -c config=$T_CONFIG -f $T_PATH >> $T_OUT
    else
      echo "Config file for $T_PATH on $T_CONFIG not exists."
      exit 2
    fi
  done
fi

exec "$@"
