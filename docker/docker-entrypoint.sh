#!/bin/sh
set -e

#rabbitmqctllist_users
# Add a new user and set a password
#rabbitmqctl add_user "$USER" "$PASS"
#rabbitmqctl set_user_tags "$USER" administrator
#rabbitmqctl set_permissions -p / "$USER" ".*" ".*" ".*"

exec "$@"
