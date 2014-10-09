#!/bin/bash

set -e

APP=popenchrome
HOST=com.$APP
JSON=$HOST.json

if [ "$(whoami)" == "root" ]; then
    TARGET_DIR="/etc/opt/chrome/native-messaging-hosts"
else
    TARGET_DIR="$HOME/.config/google-chrome/NativeMessagingHosts"
fi

rm -f $TARGET_DIR/$JSON
echo $TARGET_DIR/$JSON has been uninstalled.
