
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils 

COMMON_URI="
https://github.com/RPCS3/yaml-cpp/archive/6a211f0bc71920beef749e6c35d7d1bcc2447715.zip
https://github.com/RPCS3/llvm-mirror/archive/f5679565d34863e2f5917f6bb6d3867760862a1e.zip
https://github.com/asmjit/asmjit/archive/fc251c914e77cd079e58982cdab00a47539d7fc5.zip

https://github.com/FNA-XNA/FAudio/archive/9c7d2d1430c9dbe4e67c871dfe003b331f165412.zip
https://github.com/RPCS3/cereal/archive/60c69df968d1c72c998cd5f23ba34e2e3718a84b.zip
https://github.com/RipleyTom/curl/archive/aa1a12cb234bd31c6058d04c398a159d06b85889.zip
https://github.com/RPCS3/ffmpeg-core/archive/e5fb13bbb07ac3ba2e1998e2f5688f3714870d93.zip
https://github.com/RPCS3/ffmpeg-core/archive/e5fb13bbb07ac3ba2e1998e2f5688f3714870d93.zip
https://github.com/RPCS3/hidapi/archive/9220f5e77c27b8b3717b277ec8d3121deeb50242.zip
https://github.com/glennrp/libpng/archive/eddf9023206dc40974c26f589ee2ad63a4227a1e.zip
https://github.com/libusb/libusb/archive/e782eeb2514266f6738e242cdcb18e3ae1ed06fa.zip
https://github.com/zeux/pugixml/archive/8bf806c035373bd0723a85c0820cfd5c804bf6cd.zip
https://github.com/tcbrindle/span/archive/9d7559aabdebf569cab3480a7ea2a87948c0ae47.zip
https://github.com/RipleyTom/wolfssl/archive/f7130a4e43170ac2bb1046a65d10c01e6ec1d698.zip
https://github.com/Cyan4973/xxHash/archive/7cc9639699f64b750c0b82333dced9ea77e8436e.zip
https://github.com/RPCS3/yaml-cpp/archive/6a211f0bc71920beef749e6c35d7d1bcc2447715.zip
https://github.com/KhronosGroup/glslang/archive/ae59435606fc5bc453cf4e32320e6579ff7ea22e.zip
"

if [[ ${PV} == 9999 ]]
then
	EGIT_REPO_URI="https://github.com/RPCS3/rpcs3"
else
	SRC_URI="https://github.com/RPCS3/rpcs3/archive/v${PV}.tar.gz
	${COMMON_URI}"

	KEYWORDS="~amd64"
fi

DESCRIPTION="Very experimental PS3 emulator"
HOMEPAGE="https://rpcs3.net http://www.emunewz.net/forum/forumdisplay.php?fid=172"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa faudio pulseaudio gdb joystick +llvm -system-llvm discord-rpc pulseaudio +z3 +test vulkan"

CDEPEND="
        vulkan? ( media-libs/vulkan-loader[wayland] )
"

RDEPEND="${CDEPEND}
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	alsa? ( media-libs/alsa-lib )
	gdb? ( sys-devel/gdb )
	joystick? ( dev-libs/libevdev )
	llvm? ( sys-devel/llvm )
        media-libs/glew:0
	media-libs/libpng:*
	media-libs/openal
	pulseaudio? ( media-sound/pulseaudio )
	sys-libs/zlib
	virtual/ffmpeg
	virtual/opengl
	x11-libs/libX11
        z3? ( sci-mathematics/z3 )
        test? ( dev-cpp/gtest )
        vulkan? ( media-libs/vulkan-loader )

"


src_prepare() {
	default
	 mv ${WORKDIR}/asmjit*/*   ${S}/asmjit/            || die
	 mv ${WORKDIR}/cereal*/*   ${S}/3rdparty/cereal/   || die
     mv ${WORKDIR}/curl*/*     ${S}/3rdparty/curl/     || die
     mv ${WORKDIR}/FAudio*/*   ${S}/3rdparty/FAudio/   || die
     mv ${WORKDIR}/glslang*/*  ${S}/Vulkan/glslang/    || die
     mv ${WORKDIR}/ffmpeg*/*   ${S}/3rdparty/ffmpeg/   || die
     mv ${WORKDIR}/hidapi*/*   ${S}/3rdparty/hidapi/   || die
     mv ${WORKDIR}/libpng*/*   ${S}/3rdparty/libpng/   || die
     mv ${WORKDIR}/libusb*/*   ${S}/3rdparty/libusb/   || die
     mv ${WORKDIR}/llvm*/*     ${S}/llvm/              || die
     mv ${WORKDIR}/pugixml*/*  ${S}/3rdparty/pugixml/  || die
     mv ${WORKDIR}/span*/*     ${S}/3rdparty/span/     || die
     mv ${WORKDIR}/wolfssl*/*  ${S}/3rdparty/wolfssl/  || die
     mv ${WORKDIR}/xxHash*/*   ${S}/3rdparty/xxHash/   || die
     mv ${WORKDIR}/yaml-cpp*/* ${S}/3rdparty/yaml-cpp/ || die
     
	sed -i -e '/find_program(CCACHE_FOUND/d' CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
        "-DUSE_SYSTEM_ZLIB=ON"
		"-DUSE_SYSTEM_LIBPNG=ON"
		"-DUSE_SYSTEM_FFMPEG=ON"
		"-DUSE_VULKAN=$(usex vulkan ON OFF)"
		"-DUSE_ALSA=$(usex alsa ON OFF)"
		"-DUSE_FAUDIO=$(usex faudio ON OFF)"
		"-DUSE_DISCORD_RPC=$(usex discord-rpc ON OFF)"
		"-DUSE_PULSE=$(usex pulseaudio ON OFF)"
		"-DUSE_LIBEVDEV=$(usex joystick ON OFF)"
		"-DWITH_GDB=$(usex gdb ON OFF)"
		"-DWITH_LLVM=$(usex llvm ON OFF)"
        "-DBUILD_LLVM_SUBMODULE=$(usex system-llvm OFF ON)"
                "-Wno-dev=ON"


	)
        CCACHE_SLOPPINESS=pch_defines,time_macros
        CMAKE_BUILD_TYPE=Release
	cmake-utils_src_configure
}

#pkg_postinst() {
	# Add pax markings for hardened systems
#	pax-mark -m "${EPREFIX}"/usr/bin/"${PN}"
#}
