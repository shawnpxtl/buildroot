# if we are not running in /dev/tty0, skip animation
if [ "$(tty)" != "/dev/tty0" ]; then
    echo "Welcome to Rhodes Island Pass Debug Shell!"
    echo "You are in Terminal $(tty)."
    return
fi

memcheck

wait_any_key(){
    LAST_TIME=$(date +%s)
    echo "Press any key to continue..."
    while [ $? -eq 0 ]; do
        read -n1
        CURRENT_TIME=$(date +%s)
        ELAPSED_TIME=$((CURRENT_TIME - LAST_TIME))
        if [ $ELAPSED_TIME -ge 5 ]; then
            echo "Triggered!"
            break
        fi
    done
}

# if epass_drm_app is not present
if [ ! -f "./epass_drm_app" ]; then
    cat << EOF
  _   _  ____  _____       _______
 | \ | |/ __ \|  __ \   /\|__   __|/\
 |  \| | |  | | |  | | /  \  | |  /  \
 | . \ | |  | | |  | |/ /\ \ | | / /\ \
 | |\  | |__| | |__| / ____ \| |/ ____ \
 |_| \_|\____/|_____/_/    \_\_/_/    \_\

Please copy 'epass_drm_app' and asset files.
to app directory.

EOF
    usbctl mtp
    return
fi

cat << EOF
                      *
                     -.:@
                    :.-..*
                   :.:.:..%
                 #..:   ...+
                %..:........#
               *..%@:=@+:%%. =
              *. -@@##@%%@@= .+
             -.  =@@@@@@@@@+   :
            -... -%#+*#@@@%- .:.:
           -...   .%@@@@@%.   ...:@
          :.:.    :@@@@@@@-    ...:%
        @:..     .#@@@@@@@%.     ...#
       #:...     -@%=%@@@#%-     ....+
      #....   ..-+-:-*@@@@@#-..    ...+
     +...    .=@#..@@@@@@@@@@@-.    ...=
    *.... .::-------------------::.. .:.=
   -...=..-=--+-.=::#:=.+-::-*-=*.-..=...:
  *.......................................-

EOF
cat << EOF
---------------------------------------------
     RHODES ISLAND AUTHORIZATION PASS
   VERSION 1.0 (c) Ada.Closure.Church 1097
---------------------------------------------
EOF
echo -n -e "\e[31m"
cat << EOF
   This pass certifies that the bearer is an
 authorized operator of Rhodes Island Co'Ltd.
  Unauthorized use of Rhodes Island property
            is strictly prohibited.
EOF
echo -n -e "\e[0m"
cat << EOF
---------------------------------------------
EOF
sleep 1
echo -n -e "\e[32m"
echo "Welcome to Rhodes Island!"
echo "You are in Terminal $(tty)."
echo "Access Level: Operator"
echo -n -e "\e[0m"
echo ""
chmod +x ./epass_drm_app
./epass_drm_app version
cat /etc/os-release

mkdir /sd
mount /dev/mmcblk0p1 /sd
mount_ret=$?

if [ $mount_ret -eq 0 ]; then
    echo "SD Card Mounted!"
fi

while true; do
    chmod +x ./epass_drm_app
    ./epass_drm_app > /dev/null
    if [ $? -eq 1 ]; then
        echo "Restarting..."
        sleep 2
    elif [ $? -eq 2 ]; then
        echo "Request application start..."
        chmod +x /tmp/appstart
        /tmp/appstart
        wait_any_key
        echo "Restarting..."
        sleep 2
    else
        break
    fi
done


if [ $mount_ret -eq 0 ]; then
    umtpctl auxstart
else
    umtpctl start
fi

wait_any_key

reboot
