#!/bin/sh

# Get the latest GitHub Desktop release (url and filename)
url="$(curl -s "https://api.github.com/repos/vscodium/vscodium/releases/latest" | grep "browser_download_url.*\x86_64.rpm" | cut -d \" -f 4)"
filename="$(echo "$url" | sed "s|.*/||")"

# Installation routine
install()
{
    [ ! -x `which curl` ] && sudo dnf install curl -y
    [ -z $1 ] && echo "ERROR: Nothing to do" && exit 1
    if [ ! -f $1 ]
    then
        echo "--> Downloading the package $1..."
        curl -fSL $url -o $1
    else
        echo "--> Removing package $1..."
        [ -f "$1" ] && rm "$1"
    fi
	if [ ! -z "`rpm -qa | grep $1`" ]
    then
        echo "--> Installing the package $1..."
        sudo dnf install -y $1 > /dev/null 2>&1
    else
        echo "--> The latest version of VSCodium is already installed"
    fi
    echo "--> Removing package $1..."
    [ -f "$1" ] && rm "$1"
}

# Execute the function
install $filename
