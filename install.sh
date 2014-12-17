#!/bin/bash

set -e

APP=popenchrome
DESCRIPTION="$APP host file"
HOST=com.$APP
JSON=$HOST.json
ORIGIN=fbbbambpgamdpfjihafdpbehndhjifdf

DIR="${1:-"$( cd "$( dirname "$0" )" && pwd )"}"
if [ "$(whoami)" == "root" ]; then
    TARGET_DIR="/etc/opt/chrome/native-messaging-hosts"
else
    TARGET_DIR="$HOME/.config/google-chrome/NativeMessagingHosts"
fi

VER=`google-chrome --version | cut -d " " -f3 | cut -d "." -f1`
if [ $VER -lt 34 -a "$(whoami)" != "root" ]; then
  echo Must be root to install $TARGET_DIR/$JSON.
  exit
fi

mkdir -p $TARGET_DIR

TMPL='"%s":"%s",\n'
{
printf "{\n";
printf $TMPL "name" "$HOST";
printf $TMPL "description" "$DESCRIPTION";
printf $TMPL "path" "$DIR/$APP";
printf $TMPL "type" "stdio";
printf '"%s":["chrome-extension://%s/"]\n' "allowed_origins" "$ORIGIN";
printf "}"
} > $TARGET_DIR/$JSON

chmod o+r $TARGET_DIR/$JSON

echo $TARGET_DIR/$JSON has been installed.
