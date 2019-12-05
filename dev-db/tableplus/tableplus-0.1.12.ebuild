# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit unpacker

DESCRIPTION="Modern, native, and friendly GUI tool for relational databases (Alpha Release)"
HOMEPAGE="http://tableplus.com"
SRC_URI="https://deb.tableplus.com/debian/pool/main/t/tableplus/${PN}_${PV%.*}-${PV##*.}_amd64.deb"

# LICENSE="tableplus"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	x11-libs/gtk+:3
	x11-libs/pango
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	dev-libs/glib:2
	dev-libs/libgee:0.8
	x11-libs/gtksourceview:3.0
	dev-db/postgresql:12
	app-crypt/libsecret
	dev-libs/json-glib
	net-misc/networkmanager
	net-libs/libsoup:2.4
	sys-libs/glibc
"
DEPEND=""
BDEPEND=""
S="${WORKDIR}"

src_prepare() {
	eapply_user
	sed -i -e  "/^Exec/d" "${S}"/opt/${PN}/${PN}.desktop || die "Sed failed!"
	sed -i -e "\$aExec=env LD_LIBRARY_PATH=/opt/tableplus/resource/library/ /usr/bin/tableplus" \
		"${S}"/opt/${PN}/${PN}.desktop || die "Sed failed!"
	sed -i -e "\$aCategories=Development;Database;" "${S}"/opt/${PN}/${PN}.desktop || die "Sed failed!"
}

src_install() {
	insinto /usr/share/applications
	doins "${S}"/opt/${PN}/${PN}.desktop

	insinto /opt
	dostrip -x /opt/${PN}/${PN}
	doins -r "${S}"/opt/${PN}

	fperms 0755 /opt/${PN}/${PN}
	dosym "${EPREFIX}/opt/${PN}/${PN}" "/usr/bin/${PN}"
}
