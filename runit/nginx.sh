#!/bin/sh

# set up config based on environment
/opt/nginx_config

exec /usr/sbin/nginx
