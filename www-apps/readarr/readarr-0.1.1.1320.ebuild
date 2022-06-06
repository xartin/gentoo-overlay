# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

SRC_URI="
	amd64? ( https://github.com/Readarr/Readarr/releases/download/v${PV}/Readarr.develop.${PV}.linux-core-x64.tar.gz )
	arm? ( https://github.com/Readarr/Readarr/releases/download/v${PV}/Readarr.develop.${PV}.linux-core-arm.tar.gz )
	arm64? ( https://github.com/Readarr/Readarr/releases/download/v${PV}/Readarr.develop.${PV}.linux-core-arm64.tar.gz )
"

DESCRIPTION="Book Manager and Automation (Sonarr for Ebooks)"
HOMEPAGE="https://readarr.com"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~arm"
RESTRICT="bindist strip test"

RDEPEND="
	acct-group/readarr
	acct-user/readarr
	dev-libs/icu
	dev-util/lttng-ust
	dev-db/sqlite"

MY_PN=Readarr
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
	cp -R "${WORKDIR}/${MY_PN}/." "${D}/usr/share/readarr" || die "Install failed!"

	systemd_dounit "${FILESDIR}/readarr.service"
	systemd_newunit "${FILESDIR}/readarr.service" "${PN}@.service"
}
