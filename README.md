# gentoo-overlay
Gentoo Linux Portage net-nntp overlay for Radarr and Sonarr

Current as of 11/27/2017

/etc/portage/repos.conf/usenet-overlay.conf

[usenet-overlay]

# Gentoo overlay for Valve's Steam client and Steam-based games.
# Maintainer: anyc (https://github.com/anyc)

location = /usr/local/portage/usenet-overlay
sync-type = git
sync-uri = https://github.com/xartin/gentoo-overlay.git
priority = 50
auto-sync = Yes
