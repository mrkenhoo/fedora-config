#!/bin/sh

for f in rootfs/etc/modprobe.d/*.conf
do
    printf "\n:: Copying file ${f} to /etc/modprobe.d..."
    sudo cp "${f}" "/etc/modprobe.d/" > /dev/null 2>&1
    [ $? = "0" ] && printf " done\n" || printf " failed\n"
done

for f in rootfs/etc/profile.d/*.sh
do
    printf "\n:: Copying file ${f} to /etc/profile.d/..."
    sudo cp "${f}" "/etc/profile.d/"
    [ $? = "0" ] && printf " done\n" || printf " failed\n"
done

for f in rootfs/etc/sysctl.d/*.conf
do
    printf "\n:: Copying file ${f} to /etc/sysctl.d/..."
    sudo cp "${f}" "/etc/sysctl.d/" > /dev/null 2>&1
    [ $? = "0" ] && printf " done\n" || printf " failed\n"
done

for f in rootfs/etc/*
do
    [ ! -f "${f}" ] && break
    printf "\n:: Copying file ${f} to /etc/..."
    sudo cp "${f}" "/etc/" > /dev/null 2>&1
    [ $? = "0" ] && printf " done\n" || printf " failed\n"
done

for f in rootfs/home/.config/*
do
    printf "\n:: Copying file ${f} to $HOME/.config..."
    cp --no-preserve=ownership "${f}" "$HOME/.config" > /dev/null 2>&1
    [ $? = "0" ] && printf " done\n" || printf " failed\n"
done

printf "\n:: Copying file rootfs/home/.Xresources to $HOME..."
find `pwd` -name .Xresources -type f -exec cp --no-preserve=ownership {} $HOME \;
`which xrdb` -merge "$HOME/.Xresources"
[ $? = "0" ] && printf " done\n" || printf " failed\n"

if [ -z "`cat /etc/default/grub` | grep GRUB_DISABLE_OS_PROBER=true" ]
then
    printf "\n:: Disabling OS prober in GRUB..."
    echo "GRUB_DISABLE_OS_PROBER=true" >> "/etc/default/grub"
    [ $? = "0" ] && printf " done\n" || printf " failed\n"
fi

if [ -x "`which zsh`" ]
then
    printf "\n:: Changing `whoami`'s shell from $SHELL to /bin/zsh..."
    `which usermod` -s "/bin/zsh" `whoami` > /dev/null 2>&1
    [ $? = "0" ] && printf " done\n\n" || printf " failed\n\n"
fi

[ "`pwd`" != "$HOME" ] && cd "$HOME"

if [ ! -d "$HOME/.oh-my-zsh" ]
then
    echo ":: Installing Oh My Zsh and powerlevel10k..."
    curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | "$SHELL"
    [ -z "$ZSH_CUSTOM" ] && export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
    echo "source /etc/profile
source /etc/environment

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

autoload -Uz compinit
compinit

export PATH="$PATH:$HOME/.local/bin"" >> $HOME/.zshrc
    [ $? = 0 ] && . $HOME/.zshrc && omz theme set powerlevel10k/powerlevel10k
else
    echo ":: Reinstalling Oh My Zsh and powerlevel10k..."
    rm -rf $HOME/.oh-my-zsh
    curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | "$SHELL"
    [ -z "$ZSH_CUSTOM" ] && export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
    echo "source /etc/profile
source /etc/environment

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

autoload -Uz compinit
compinit

export PATH="$PATH:$HOME/.local/bin"" >> $HOME/.zshrc
    [ $? = 0 ] && `which zsh` -c ". $HOME/.zshrc && omz theme set powerlevel10k/powerlevel10k"
    echo "Please restart your terminal emulator or your computer to configure powerlevel10k"
fi
