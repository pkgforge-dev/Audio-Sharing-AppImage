#!/bin/sh

set -eux

ARCH="$(uname -m)"
VERSION="$(cat ~/version)"
SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"

# Variables used by quick-sharun
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export OUTNAME=Audio-Sharing-"$VERSION"-anylinux-"$ARCH".AppImage
export DESKTOP=/usr/share/applications/de.haeckerfelix.AudioSharing.desktop
export ICON=/usr/share/icons/hicolor/scalable/apps/de.haeckerfelix.AudioSharing.svg
export DEPLOY_OPENGL=1
export DEPLOY_GSTREAMER=1
export STARTUPWMCLASS=audio-sharing # For Wayland, this is 'de.haeckerfelix.AudioSharing', so this needs to be changed in desktop file manually by the user in that case until some potential automatic fix exists for this
export LOCALE_FIX=1 # Fixes crash when it fails to switch libc locale in alpine linux

# Trace and deploy all files and directories needed for the application (including binaries, libraries and others)
wget --retry-connrefused --tries=30 "$SHARUN" -O ./quick-sharun
chmod +x ./quick-sharun
./quick-sharun /usr/bin/audio-sharing

## Set gsettings to save to keyfile, instead to dconf
echo "GSETTINGS_BACKEND=keyfile" >> ./AppDir/.env

# Make the AppImage with uruntime
./quick-sharun --make-appimage

# Prepare the AppImage for release
mkdir -p ./dist
mv -v ./*.AppImage* ./dist
mv -v ~/version     ./dist
