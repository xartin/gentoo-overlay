# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for lidarr"
ACCT_USER_ID=127
ACCT_USER_HOME=/var/lib/lidarr
ACCT_USER_GROUPS=( lidarr )

acct-user_add_deps
