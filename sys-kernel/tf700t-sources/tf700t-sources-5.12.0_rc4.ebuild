# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ETYPE=sources
K_DEFCONFIG="tegra3_defconfig"
K_SECURITY_UNSUPPORTED=1
EXTRAVERSION="-${PN}/-*"
inherit kernel-2
detect_version
detect_arch

DESCRIPTION="Asus Transformers pad tf700t kernel sources"
HOMEPAGE="https://github.com/clamor95/linux"

inherit  eapi7-ver
IUSE="config"
COMMIT="c1c0020b1593cb3cbdfa415ab618fbe180ac572b"
SRC_URI="
https://github.com/clamor95/linux/archive/${COMMIT}.tar.gz -> linux-${KV_FULL}.tar.gz
	config? ( https://raw.githubusercontent.com/hedmo/stuff/main/dot_files/.config-transformers -> .config )
"

KEYWORDS="~arm"

src_unpack() {
	default

	# We want to rename the unpacked directory to a nice normalised string
	# bug #762766
	mv "${WORKDIR}"/linux-${COMMIT} "${WORKDIR}"/linux-${KV_FULL} || die
}

src_prepare() {
	#if one wants to use my .config 
	if use config; then
	cp "${DISTDIR}"/.config "${WORKDIR}"/linux-${KV_FULL}/ || die 
	fi
}
