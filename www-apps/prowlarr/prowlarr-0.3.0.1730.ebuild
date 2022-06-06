# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

SRC_URI="
	amd64? ( https://github.com/Prowlarr/Prowlarr/releases/download/v${PV}/Prowlarr.develop.${PV}.linux-core-x64.tar.gz )
	arm? ( https://github.com/Prowlarr/Prowlarr/releases/download/v${PV}/Prowlarr.develop.${PV}.linux-core-arm.tar.gz )
	arm64? ( https://github.com/Prowlarr/Prowlarr/releases/download/v${PV}/Prowlarr.develop.${PV}.linux-core-arm64.tar.gz )
"

DESCRIPTION="An indexer manager/proxy to integrate with your various PVR apps."
HOMEPAGE="https://wiki.servarr.com/prowlarr"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~arm"
RESTRICT="bindist strip test"

RDEPEND="
	acct-group/prowlarr
	acct-user/prowlarr
	dev-libs/icu
	dev-util/lttng-ust
	dev-db/sqlite"

MY_PN=Prowlarr
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
	cp -R "${WORKDIR}/${MY_PN}/." "${D}/usr/share/prowlarr" || die "Install failed!"

	systemd_dounit "${FILESDIR}/prowlarr.service"
	systemd_newunit "${FILESDIR}/prowlarr.service" "${PN}@.service"
}
