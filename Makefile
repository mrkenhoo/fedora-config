all: setup-rootfs

setup-rootfs: setup-services
	[ -f "rootfs/setup.sh" ] && sh "rootfs/setup.sh"

setup-services: install-packages
	sudo systemctl enable --now firewalld.service && \
		sudo systemctl enable --now bluetooth.service && \
		sudo systemctl enable --now libvirtd.socket && \
		sudo systemctl enable --now libvirtd-ro.socket && \
		sudo systemctl enable --now libvirtd-admin.socket && \
		sudo systemctl enable --now cronie.service && \
		sudo systemctl enable --now fstrim.timer && \
		sudo systemctl enable --now clamav-freshclam.service || exit 1

install-packages:
	[ -f "packages/setup.sh" ] && sh "packages/setup.sh"
