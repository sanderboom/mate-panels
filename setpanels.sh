#!/bin/sh
# 2014 Sander Boom
# Toggle between MATE panels setup for single and dual monitor. Top and bottom
# panel per monitor. Bottom panel contains the WindowList applet.

usage()
{
cat << EOF
usage: $0 options

OPTIONS:
   -h      Show this message
   -r      Reset to default single monitor setup
EOF
}

RESET=
while getopts "rh" OPTION
do
   case $OPTION in
     h)
       usage
       exit 1
       ;;
     r)
       echo -e "Resetting!\n"
       RESET=1
       ;;
   esac
done

CURR=`dconf read /org/mate/panel/general/toplevel-id-list`
echo -e "Current state is:" $CURR

if [ "$RESET" == 1 ] || [ "$CURR" == "['top', 'toplevel_0', 'toplevel_1', 'toplevel_2']" ]
  then
    echo "Resetting to default single monitor setup"
    dconf reset -f /org/mate/panel/objects/toplevel_2_windowlist/
    dconf reset -f /org/mate/panel/toplevels/toplevel_1/
    dconf reset -f /org/mate/panel/toplevels/toplevel_2/
    dconf write /org/mate/panel/general/toplevel-id-list "['top', 'toplevel_0']"

elif [ "$CURR" == "['top', 'toplevel_0']" ]
  then
    echo "One monitor panel setup detected"
    echo "Setting dual monitor panel setup"

    dconf write /org/mate/panel/toplevels/toplevel_1/screen 0
    dconf write /org/mate/panel/toplevels/toplevel_1/monitor 2
    dconf write /org/mate/panel/toplevels/toplevel_1/orientation "'top'"
    dconf write /org/mate/panel/general/toplevel-id-list "['top', 'toplevel_0', 'toplevel_1']"

    dconf write /org/mate/panel/toplevels/toplevel_2/screen 0
    dconf write /org/mate/panel/toplevels/toplevel_2/monitor 2
    dconf write /org/mate/panel/toplevels/toplevel_2/orientation "'bottom'"
    dconf write /org/mate/panel/general/toplevel-id-list "['top', 'toplevel_0', 'toplevel_1', 'toplevel_2']"

    dconf write /org/mate/panel/objects/toplevel_2_windowlist/object-type "'applet'"
    dconf write /org/mate/panel/objects/toplevel_2_windowlist/toplevel-id "'toplevel_2'"
    dconf write /org/mate/panel/objects/toplevel_2_windowlist/position 0
    dconf write /org/mate/panel/objects/toplevel_2_windowlist/panel-right-stick false
    dconf write /org/mate/panel/objects/toplevel_2_windowlist/applet-iid "'WnckletFactory::WindowListApplet'"
else
  echo "Unknown panel setup"
fi

echo "Current state is:" `dconf read /org/mate/panel/general/toplevel-id-list`
