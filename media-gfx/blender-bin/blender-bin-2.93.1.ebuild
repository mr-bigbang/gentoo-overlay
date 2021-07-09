# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="https://www.blender.org"

LICENSE="|| ( GPL-3 BL )"
SRC_URI="https://ftp.halifax.rwth-aachen.de/blender/release/Blender2.93/blender-${PV}-linux-x64.tar.xz"
SLOT="0"
KEYWORDS="-* ~amd64"
S="${WORKDIR}/blender-${PV}-linux-x64"

src_install() {
	insinto /opt/blender-bin
	doins -r "${S}/2.93"
	doins -r "${S}/lib"

	exeinto /opt/blender-bin
    doexe ${S}/blender

	dosym "/opt/${PN}/blender" /usr/bin/blender

	domenu ${S}/blender.desktop
    doicon ${S}/blender-symbolic.svg
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
