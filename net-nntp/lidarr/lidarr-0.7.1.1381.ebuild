# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user systemd

SRC_URI="https://github.com/lidarr/Lidarr/releases/download/v${PV}/Lidarr.master.${PV}.linux.tar.gz"

DESCRIPTION="Lidarr is a music collection manager for Usenet and BitTorrent users."
HOMEPAGE="https://github.com/lidarr/Lidarr"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND="
        >=dev-lang/mono-4.4.1.0
        media-video/mediainfo
        dev-db/sqlite
        media-libs/chromaprint[tools]"

MY_PN=lidarr
S="${WORKDIR}/Lidarr"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/lidarr ${PN}
}

src_install() {
	newconfd "${FILESDIR}/${PN}.conf" ${PN}
	newinitd "${FILESDIR}/${PN}.init" ${PN}

	keepdir /var/lib/${PN}
	fowners -R ${PN}:${PN} /var/lib/${PN}

	insinto /etc/${PN}
	insopts -m0660 -o ${PN} -g ${PN}

	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	dodir  "/usr/share/${PN}"
	cp -R "${WORKDIR}/Lidarr/." "${D}/usr/share/lidarr" || die "Install failed!"

	systemd_dounit "${FILESDIR}/lidarr.service"
	systemd_newunit "${FILESDIR}/lidarr.service" "${PN}@.service"
}
