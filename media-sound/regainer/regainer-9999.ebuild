# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_USER="kepstin"
KEYWORDS="~amd64 ~x86"

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml

inherit github-pkg distutils-r1

DESCRIPTION="Multi-format ReplayGain scanner and tagger"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep "media-libs/mutagen[\${PYTHON_USEDEP}]")
	media-video/ffmpeg"
DEPEND="${RDEPEND}"
