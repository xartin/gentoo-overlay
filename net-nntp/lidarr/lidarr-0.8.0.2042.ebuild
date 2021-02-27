# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

SRC_URI="https://github.com/lidarr/Lidarr/releases/download/v${PV}/Lidarr.develop.${PV}.linux-core-x64.tar.gz"

DESCRIPTION="Lidarr is a music collection manager for Usenet and BitTorrent users."
HOMEPAGE="https://github.com/lidarr/Lidarr"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND="
	acct-group/lidarr
	acct-user/lidarr
	media-video/mediainfo
	dev-util/lttng-ust
	dev-db/sqlite
	media-libs/chromaprint[tools]"

MY_PN=lidarr
S="${WORKDIR}/Lidarr"

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
