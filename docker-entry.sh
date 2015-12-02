#!/bin/bash
# vim:ts=4:sw=4:et:
if test -f "/home/air/bin/$1" ; then

    if [ $1 == adl ]; then
        su air -c "Xorg -noreset +extension GLX +extension RANDR +extension RENDER -logfile ./xorg.0.log -config /xorg.conf :83" &
        sleep 5
        export DISPLAY=:83
        export WINEDEBUG=-all
        su air -c "/home/air/bin/$*"
        su air -c "killall Xorg"
    else
        su air -c "/home/air/bin/$*"
    fi

else
    exec "$@"
fi
