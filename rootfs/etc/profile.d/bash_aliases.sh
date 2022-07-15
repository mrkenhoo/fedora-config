#!/bin/sh
#
# custom user-based aliases
#

# enable/disable app root access (xwayland)
alias ron='xhost si:localuser:root'
alias roff='xhost -si:localuser:root'

# detailed file and directory listing
alias ll='ls -alih --color=auto'
alias ls='ls --color=auto'

# short version of apt commands
alias ipkg='sudo dnf install'
alias updpkg='sudo dnf update'
alias ppkg='sudo dnf remove'

# others
alias adb='sudo adb'
alias fastboot='sudo fastboot'
alias update-initramfs='sudo mkinitcpio -P -v'

alias wake-up-system='[ ! -z "${mac_address}" ] && wol ${mac_address} || echo "No MAC address specified"'

alias allow-unprivileged-userns-clone='sysctl kernel.unprivileged_userns_clone=1'
