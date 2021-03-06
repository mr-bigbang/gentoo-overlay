# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils udev

DESCRIPTION="DisplayLink USB Graphics Software"
HOMEPAGE="http://www.displaylink.com/downloads/ubuntu"
SRC_URI="${P}.zip"

LICENSE="DisplayLink-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86 "

QA_PREBUILT="/opt/displaylink/DisplayLinkManager"
RESTRICT="fetch bindist"

DEPEND="app-admin/chrpath
	app-arch/unzip"
RDEPEND=">=sys-devel/gcc-6.5.0
	=x11-drivers/evdi-1.9*
	virtual/libusb:1
	>=x11-base/xorg-server-1.17.0
	sys-auth/elogind"

pkg_nofetch() {
	einfo "Please download DisplayLink USB Graphics Software for Ubuntu 5.4.zip from"
	einfo "http://www.displaylink.com/downloads/ubuntu"
	einfo "and rename it to ${P}.zip"
	# /usr/portage/distfiles/displaylink-driver-5.4.zip
}

src_unpack() {
	default
	sh ./"${PN}"-"5.4.0-55.153".run --noexec --target "${P}"
}

src_install() {
	MY_UBUNTU_VERSION=1604
	einfo "Using package for Ubuntu ${MY_UBUNTU_VERSION} based on your gcc version: $(gcc-version)"

	case "${ARCH}" in
		amd64)	MY_ARCH="x64" ;;
		*)		MY_ARCH="${ARCH}" ;;
	esac
	DLM="${S}/${MY_ARCH}-ubuntu-${MY_UBUNTU_VERSION}/DisplayLinkManager"

	dodir /opt/displaylink
	keepdir /var/log/displaylink

	exeinto /opt/displaylink
	chrpath -d "${DLM}"
	doexe "${DLM}"

	insinto /opt/displaylink
	doins *.spkg

	udev_dorules "${FILESDIR}/99-displaylink.rules"

	insinto /opt/displaylink
	insopts -m0755
	newins "${FILESDIR}/udev.sh" udev.sh
	newins "${FILESDIR}/pm-displaylink" suspend.sh
	dosym ../../../opt/displaylink/suspend.sh /etc/pm/sleep.d/displaylink.sh
	newinitd "${FILESDIR}/rc-displaylink-1.3" dlm
}

pkg_postinst() {
	einfo "The DisplayLinkManager Init is now called dlm"
	einfo ""
	einfo "You should be able to use xrandr as follows:"
	einfo "xrandr --setprovideroutputsource 1 0"
	einfo "Repeat for more screens, like:"
	einfo "xrandr --setprovideroutputsource 2 0"
	einfo "Then, you can use xrandr or GUI tools like arandr to configure the screens, e.g."
	einfo "xrandr --output DVI-1-0 --auto"
}
