# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for tautulli"
ACCT_USER_HOME=/var/lib/tautulli
ACCT_USER_ID=100
ACCT_USER_GROUPS=( tautulli )

acct-user_add_deps
