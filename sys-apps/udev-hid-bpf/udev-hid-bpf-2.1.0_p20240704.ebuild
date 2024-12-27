# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Auto-Generated by cargo-ebuild 0.5.4-r1

EAPI=8

MY_PV="${PV/_p/-}"

CRATES="
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.13
	anstyle@1.0.6
	anstyle-parse@0.2.3
	anstyle-query@1.0.2
	anstyle-wincon@3.0.2
	anyhow@1.0.82
	atty@0.2.14
	autocfg@1.2.0
	bitflags@2.5.0
	bumpalo@3.16.0
	camino@1.1.6
	cargo-platform@0.1.8
	cargo_metadata@0.15.4
	cc@1.0.95
	cfg-if@1.0.0
	cfg_aliases@0.1.1
	chrono@0.4.38
	clap@4.5.4
	clap_builder@4.5.2
	clap_derive@4.5.4
	clap_lex@0.7.0
	colorchoice@1.0.0
	core-foundation-sys@0.8.6
	errno@0.3.8
	fastrand@2.0.2
	heck@0.4.1
	heck@0.5.0
	hermit-abi@0.1.19
	iana-time-zone@0.1.60
	iana-time-zone-haiku@0.1.2
	itoa@1.0.11
	js-sys@0.3.69
	libbpf-cargo@0.23.3
	libbpf-rs@0.23.3
	libbpf-sys@1.4.2+v1.4.2
	libc@0.2.153
	libudev-sys@0.1.4
	linux-raw-sys@0.4.13
	log@0.4.21
	memchr@2.7.2
	memmap2@0.5.10
	mio@0.8.11
	nix@0.28.0
	num-traits@0.2.18
	once_cell@1.19.0
	pkg-config@0.3.30
	proc-macro2@1.0.81
	quote@1.0.36
	regex@1.10.4
	regex-automata@0.4.6
	regex-syntax@0.8.3
	rustix@0.38.33
	rustversion@1.0.15
	ryu@1.0.17
	semver@1.0.22
	serde@1.0.198
	serde_derive@1.0.198
	serde_json@1.0.116
	stderrlog@0.5.4
	strsim@0.11.1
	strum_macros@0.24.3
	syn@1.0.109
	syn@2.0.60
	tempfile@3.10.1
	termcolor@1.1.3
	thiserror@1.0.59
	thiserror-impl@1.0.59
	thread_local@1.1.8
	udev@0.7.0
	unicode-ident@1.0.12
	utf8parse@0.2.1
	vsprintf@2.0.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen@0.2.92
	wasm-bindgen-backend@0.2.92
	wasm-bindgen-macro@0.2.92
	wasm-bindgen-macro-support@0.2.92
	wasm-bindgen-shared@0.2.92
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows-core@0.52.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.5
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.5
	windows_i686_gnullvm@0.52.5
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.5
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.5
"

inherit cargo

DESCRIPTION="An automatic HID-BPF loader based on udev events"
# Double check the homepage as the cargo_metadata crate
# does not provide this value so instead repository is used
HOMEPAGE="https://libevdev.pages.freedesktop.org/udev-hid-bpf/"
SRC_URI="
	${CARGO_CRATE_URIS}
	https://gitlab.freedesktop.org/libevdev/${PN}/-/archive/${MY_PV}/${PN}-${MY_PV}.tar.bz2
"
S="${WORKDIR}/${PN}-${MY_PV}"

# License set may be more restrictive as OR is not respected
# use cargo-license for a more accurate license picture
LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 Boost-1.0 GPL-2 LGPL-2.1 MIT Unicode-DFS-2016 Unlicense"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="virtual/libudev virtual/libelf"
RDEPEND="${DEPEND}"
BDEPEND="llvm-core/clang[llvm_targets_BPF]"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_install() {
	newman "${S}"/udev-hid-bpf.man udev-hid-bpf.1
	cargo_src_install
}
