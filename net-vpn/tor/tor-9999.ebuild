# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

EGIT_REPO_URI="https://gitlab.torproject.org/tpo/core/tor"

inherit flag-o-matic readme.gentoo-r1 git-r3

MY_PV="$(ver_rs 4 -)"
DESCRIPTION="Anonymizing overlay network for TCP"
HOMEPAGE="http://www.torproject.org/"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~ppc-macos"
IUSE="caps doc libressl lzma +man scrypt seccomp selinux +server systemd tor-hardening test zstd"

DEPEND="
	dev-libs/libevent:=[ssl]
	sys-libs/zlib
	caps? ( sys-libs/libcap )
	man? ( app-text/asciidoc )
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:0= )
	lzma? ( app-arch/xz-utils )
	scrypt? ( app-crypt/libscrypt )
	seccomp? ( >=sys-libs/libseccomp-2.4.1 )
	systemd? ( sys-apps/systemd )
	zstd? ( app-arch/zstd )"
RDEPEND="
	acct-user/tor
	acct-group/tor
	${DEPEND}
	selinux? ( sec-policy/selinux-tor )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.7.4-torrc.sample.patch
)

DOCS=()

RESTRICT="!test? ( test )"

src_configure() {
	use doc && DOCS+=( README ChangeLog ReleaseNotes doc/HACKING )
	export ac_cv_lib_cap_cap_init=$(usex caps)
	./autogen.sh
	econf \
		--localstatedir="${EPREFIX}/var" \
		--disable-all-bugs-are-fatal \\
		--disable-android \
		--disable-coverage \
		--disable-html-manual \
		--disable-libfuzzer \
		--enable-missing-doc-warnings \
		--disable-module-dirauth \
		--enable-pic \
		--disable-restart-debugging \
		--disable-rust \
		--enable-system-torrc \
		$(use_enable man asciidoc) \
		$(use_enable man manpage) \
		$(use_enable lzma) \
		$(use_enable scrypt libscrypt) \
		$(use_enable seccomp) \
		$(use_enable server module-relay) \
		$(use_enable systemd) \
		$(use_enable tor-hardening gcc-hardening) \
		$(use_enable tor-hardening linker-hardening) \
		$(use_enable test unittests) \
		$(use_enable zstd zstd-advanced-apis)
}

src_install() {
	default
	readme.gentoo_create_doc

	newconfd "${FILESDIR}"/tor.confd tor
	newinitd "${FILESDIR}"/tor.initd-r9 tor

	keepdir /var/lib/tor

	fperms 750 /var/lib/tor
	fowners tor:tor /var/lib/tor

	insinto /etc/tor/
	newins "${FILESDIR}"/torrc-r2 torrc
}
