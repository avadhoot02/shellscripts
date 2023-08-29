#!/bin/bash

if [ $1 == 0 ]; then
# Set the desktop icons mode to 'none'
xfconf-query -c xfce4-desktop -p /desktop-icons/style -s 0
# Refresh the desktop
xfdesktop --reload

elif [ $1 == 1 ]; then
# Set the desktop icons mode to 'none'
xfconf-query -c xfce4-desktop -p /desktop-icons/style -s 2
# Refresh the desktop
xfdesktop --reload
else {

echo "invalid input !"
echo "This script takes only one argument as input choose either 0 or 1"
exit 1
}
fi

# function to create desktop entry

desk_entry(){

if [ ! -d ~/.config/autostart ]; then
echo "autosatrt dir not exist creating new "
mkdir -p ~/.config/autostart/
fi 

if [ -e  ~/.config/autostart/remmina.desktop ]; then
#remove existing file
echo "removing old entry" 
rm ~/.config/autostart/remmina.desktop
fi
echo "creating auto start remmina desktop entry."
# Create the desktop entry file
cat > ~/.config/autostart/remmina.desktop <<EOL
[Desktop Entry]
Type=Application
Exec=/usr/bin/remmina
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=Run Remmina
Name=Run Remmina
Comment[en_US]=Run Remmina on user login
Comment=Run Remmina on user login
EOL
echo "Autostart entry for Remmina created."

echo "Rebooting device"

 systemctl -i reboot

# Get the username of the user who is running the script
# target_user=$(whoami)

# Log out the user by killing their processes
# pkill -u $target_user


}
# Check if Remmina is installed
if command -v remmina &>/dev/null; then
    # Create the autostart entrt
	echo "remmina is already installed"

	desk_entry

else
    echo "Remmina is not installed. Installing..."
      sudo apt update
      sudo apt install -y remmina
      desk_entry

fi


