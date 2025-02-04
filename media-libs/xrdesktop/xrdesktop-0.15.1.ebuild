# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit meson python-r1

DESCRIPTION="A library for XR interaction with traditional desktop compositors."
HOMEPAGE="https://gitlab.freedesktop.org/xrdesktop/xrdesktop"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xrdesktop/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/xrdesktop/${PN}/-/archive/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""
REQUIRED_USE=""

DEPEND="
	>=media-libs/gxr-0.13.0
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"
pkg_setup() {
       python_setup
        }
