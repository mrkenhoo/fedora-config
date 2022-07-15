#!/bin/sh

# Get the latest GitHub Desktop release (url and filename)
url="$(curl -s "https://api.github.com/repos/eneshecan/whatsapp-for-linux/releases/latest" | grep "browser_download_url.*\.AppImage" | cut -d \" -f 4)"
filename="$(echo "$url" | sed "s|.*/||")"
folder="whatsapp-for-linux"

# Installation routine
install()
{
    [ -z $1 ] && echo "ERROR: Nothing to do" && exit 1
    [ -f $1 ] && echo "--> Removing previous package $1..." && rm $1
    echo "--> Downloading the package $1..."
    curl -L $url -o $1
    echo "--> Installing the package $1..."
    [ ! -d "/opt/$folder" ] && sudo mkdir -p "/opt/$folder"
    sudo cp --no-preserve=ownership "$1" "/opt/$folder/$1"
    echo "--> Preparing the package $1..."
    sudo chmod +x "/opt/$folder/$1"
    sudo cp --no-preserve=ownership "$folder.desktop" "/usr/share/applications/$folder.desktop"
	if [ $? = "0" ]
	then
        echo "--> The package $1 was installed successfully."
    else
        echo "An error occurred."
        exit 1
    fi
}

# Execute the function
install $filename
