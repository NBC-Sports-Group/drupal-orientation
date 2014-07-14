#!/bin/sh

cd /usr/local/bin
if [ -f "/usr/local/bin/wget" ];
then
    wget https://raw.githubusercontent.com/klausi/pareviewsh/7.x-1.x/pareview.sh
else
    curl -O https://raw.githubusercontent.com/klausi/pareviewsh/7.x-1.x/pareview.sh
fi

chmod +x /usr/local/bin/pareview.sh

