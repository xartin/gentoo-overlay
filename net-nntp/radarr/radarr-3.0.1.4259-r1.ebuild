# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

SRC_URI="https://github.com/Radarr/Radarr/releases/download/v${PV}/Radarr.master.${PV}.linux-core-x64.tar.gz"

DESCRIPTION="A fork of Sonarr to work with movies a la Couchpotato."
HOMEPAGE="https://www.radarr.video"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND="
	acct-group/radarr
	acct-user/radarr
	>=dev-lang/mono-6.6.0.161
	media-video/mediainfo
	dev-util/lttng-ust
	dev-db/sqlite"

MY_PN=Radarr
S="${WORKDIR}/${MY_PN}"

src_install() {
	newconfd "${FILESDIR}/${PN}.conf" ${PN}
	newinitd "${FILESDIR}/${PN}-v3.init" ${PN}

	keepdir /var/lib/${PN}
	fowners -R ${PN}:${PN} /var/lib/${PN}

	insinto /etc/${PN}
	insopts -m0660 -o ${PN} -g ${PN}

	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	dodir  "/usr/share/${PN}"
	cp -R "${WORKDIR}/${MY_PN}/." "${D}/usr/share/radarr" || die "Install failed!"

	systemd_dounit "${FILESDIR}/radarr-v3.service"
	systemd_newunit "${FILESDIR}/radarr-v3.service" "${PN}@.service"
}
