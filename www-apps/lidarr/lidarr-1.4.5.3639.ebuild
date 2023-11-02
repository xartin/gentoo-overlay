# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

SRC_URI="
	x86? ( https://github.com/lidarr/Lidarr/releases/download/v${PV}/Lidarr.master.${PV}.linux-core-x86.tar.gz )
	amd64? ( https://github.com/lidarr/Lidarr/releases/download/v${PV}/Lidarr.master.${PV}.linux-core-x64.tar.gz )
	arm? ( https://github.com/lidarr/Lidarr/releases/download/v${PV}/Lidarr.master.${PV}.linux-core-arm.tar.gz )
	arm64? ( https://github.com/lidarr/Lidarr/releases/download/v${PV}/Lidarr.master.${PV}.linux-core-arm64.tar.gz )
"

DESCRIPTION="Lidarr is a music collection manager for Usenet and BitTorrent users."
HOMEPAGE="https://github.com/lidarr/Lidarr"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="bindist strip test"

RDEPEND="
	acct-group/lidarr
	acct-user/lidarr
	dev-libs/icu
	dev-util/lttng-ust:0
	dev-db/sqlite"

QA_PREBUILT="*"

S="${WORKDIR}/Lidarr"

src_prepare() {
	default

	# https://github.com/dotnet/runtime/issues/57784
	rm libcoreclrtraceptprovider.so Lidarr.Update/libcoreclrtraceptprovider.so || die
}

src_install() {
	newinitd "${FILESDIR}/${PN}.init" ${PN}

	keepdir /var/lib/${PN}
	fowners -R ${PN}:${PN} /var/lib/${PN}

	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	dodir  "/opt/${PN}"
	cp -R "${S}/." "${D}/opt/lidarr" || die "Install failed!"

	systemd_dounit "${FILESDIR}/lidarr.service"
	systemd_newunit "${FILESDIR}/lidarr.service" "${PN}@.service"
}
