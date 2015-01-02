#!/bin/sh

set -e

# Build all plugins

# This script run from main build.sh script
# If you run it direct, set up $lazbuild first

# CD to plugins directory
basedir=$(pwd)
cd plugins

# WCX plugins
$lazbuild wcx/cpio/src/cpio.lpi $DC_ARCH
$lazbuild wcx/deb/src/deb.lpi $DC_ARCH
$lazbuild wcx/rpm/src/rpm.lpi $DC_ARCH
$lazbuild wcx/unrar/src/unrar.lpi $DC_ARCH
$lazbuild wcx/zip/src/Zip.lpi $DC_ARCH

# WDX plugins
$lazbuild wdx/rpm_wdx/src/rpm_wdx.lpi $DC_ARCH
$lazbuild wdx/deb_wdx/src/deb_wdx.lpi $DC_ARCH
$lazbuild wdx/svn_wdx/src/svn_wdx.lpi $DC_ARCH
$lazbuild wdx/xpi_wdx/src/xpi_wdx.lpi $DC_ARCH

# WFX plugins
$lazbuild wfx/ftp/src/ftp.lpi $DC_ARCH

# Don't build under OS X
if [ -z $(uname | grep Darwin) ]; then

  $lazbuild wfx/samba/src/samba.lpi $DC_ARCH

  # WLX plugins
  $lazbuild wlx/WlxMplayer/src/wlxMplayer.lpi $DC_ARCH

fi

# DSX plugins
$lazbuild dsx/DSXLocate/src/DSXLocate.lpi $DC_ARCH

# Return from plugins directory
cd $basedir
