# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

SRC_URI="https://download.sonarr.tv/v3/main/${PV}/Sonarr.main.${PV}.linux.tar.gz"

DESCRIPTION="Sonarr is a Smart PVR for newsgroup and bittorrent users."
HOMEPAGE="https://www.sonarr.tv"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist strip test"

RDEPEND="
	acct-group/sonarr
	acct-user/sonarr
	>=dev-lang/mono-6.6.0.161
	media-video/mediainfo
	dev-db/sqlite"

MY_PN=Sonarr
S="${WORKDIR}/${MY_PN}"

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
	cp -R "${WORKDIR}/${MY_PN}/." "${D}/usr/share/sonarr" || die "Install failed!"

	systemd_dounit "${FILESDIR}/sonarr.service"
	systemd_newunit "${FILESDIR}/sonarr.service" "${PN}@.service"
}
