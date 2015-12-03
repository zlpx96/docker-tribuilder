#!/bin/bash
# vim:ts=4:sw=4:et:

. /home/air/setenv

# Make sure PATH is set correctly for use 'air'
cat /etc/login.defs|grep -v ENV_PATH > /etc/login.defs.new
echo "ENV_PATH PATH=$PATH" >> /etc/login.defs.new
mv /etc/login.defs.new /etc/login.defs

# Link 'adt' for windows version
ln -s /home/air/bin/adt /opt/air_sdk/bin/adt

mv /opt/air_sdk/bin/mxmlc /opt/air_sdk/bin/mxmlc.orig
cat << EOF > /opt/air_sdk/bin/mxmlc
. /home/air/setenv
/opt/air_sdk/bin/mxmlc.orig "\$@"
EOF
chmod +x /opt/air_sdk/bin/mxmlc

if test -f "/home/air/bin/$1" ; then

    if [ $1 == adl ]; then
        Xorg -noreset +extension GLX +extension RANDR +extension RENDER -logfile ./xorg.0.log -config /xorg.conf :83 &
        sleep 5
        export DISPLAY=:83
        export WINEDEBUG=-all
        /home/air/bin/$*
        killall Xorg
    else
        /home/air/bin/$*
    fi

elif [ _$1 = _su ]; then
    exec "$@"
else
    su air -c "$*"
fi
