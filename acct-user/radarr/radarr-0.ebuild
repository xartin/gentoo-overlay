# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for radarr"
ACCT_USER_HOME=/var/lib/radarr
ACCT_USER_ID=116
ACCT_USER_GROUPS=( radarr )

acct-user_add_deps
