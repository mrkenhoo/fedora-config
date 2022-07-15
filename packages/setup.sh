#!/bin/sh

install_extra_packages()
{
    if [ ! -d "packages/proton-ge-custom-updater" ]
    then
        git -C "packages" clone https://github.com/p-mng/proton-ge-custom-updater.git
        for s in packages/proton-ge-custom-updater/*.sh
        do
            if [ ! -f "/usr/local/bin/$s" ]
            then
                echo ":: Copying script $s to /usr/local/bin..."
                sudo cp "$s" "/usr/local/bin/$s"
                [ $? = "0" ] && printf " done\n" || printf " failed\n"
            fi
        done
    else
        for s in packages/proton-ge-custom-updater/*.sh
        do
            [ ! -f "/usr/local/bin/$s" ] && sudo cp "$s" "/usr/local/bin"
        done
    fi
    if [ -f "packages/pkglist" ]
    then
        sudo dnf install -y `cat packages/pkglist`
    else
        echo ":: ERROR: Could not find the file packages/pkglist"
    fi
}

if [ ! -x "`which git`" ]
then
    sudo dnf install -y git
    install_extra_packages
    sh packages/download-codium.sh
    sh packages/download-github-desktop.sh
    sh packages/download-whatsapp-for-linux.sh
else
    install_extra_packages
    sh packages/download-codium.sh
    sh packages/download-github-desktop.sh
    sh packages/download-whatsapp-for-linux.sh
fi

sudo dnf update -y