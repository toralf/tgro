# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )
inherit distutils-r1

MY_PN="Flask-HTTPAuth"

DESCRIPTION="Provides Basic and Digest HTTP authentication for Flask routes"
SRC_URI="https://github.com/miguelgrinberg/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/flask[${PYTHON_USEDEP}]"
BDEPEND=""

S="${WORKDIR}/${MY_PN}-${PV}"
