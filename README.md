# Gentoo Linux Portage overlay for Lidarr, Radarr and Sonarr

Current as of 26/02/2020

Maintainer: xartin / ali3nx (https://github.com/xartin) (https://reddit.com/u/xartin) (https://forums.gentoo.org/profile.php?mode=viewprofile&u=30381)

Usage
-----

* eselect repository can be used to add this repository from the official supported list at https://overlays.gentoo.org or
* Copy `usenet-overlay.conf` from this repository into `/etc/portage/repos.conf/` to use the new [portage sync capabilities](https://wiki.gentoo.org/wiki/Project:Portage/Sync)
* `emaint sync -r usenet-overlay` or `emerge --sync` to download the contents into Gentoo portage repos.  

Notes
-----

This repo has been updated for GLEP 81 QA compliance. Old ebuilds purged 26/02/2020 (https://www.gentoo.org/glep/glep-0081.html)
