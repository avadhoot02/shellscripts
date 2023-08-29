#!/bin/bash

config_file="$HOME/.config/lxsession/Lubuntu/autostart"

clr_file(){
if [ -e "$config_file" ]; then
        echo "clearing old file"    
        rm -rf "$config_file"
fi
}
if [ "$1" -eq 0 ]; then
     clr_file
    echo "writing in new file"
    echo "Desktop will be hidden"
    echo "@pcmanfm --desktop-off" > "$config_file"

elif [ "$1" -eq 1 ]; then
    clr_file
    echo "Desktop will be visible"
    echo "writing in new file"
    echo "@pcmanfm --desktop" > "$config_file"

else

    echo "Invalid argument. Usage: $0 <0|1>"
    echo "0-> To hide desktop"
    echo "1-> To show desktop"

    exit 1
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

# pkill pcmanfm

# lxpanelctl restart

 systemctl -i reboot

exit 0

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


