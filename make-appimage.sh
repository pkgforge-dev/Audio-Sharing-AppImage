#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q audio-sharing | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/de.haeckerfelix.AudioSharing.svg
export DESKTOP=/usr/share/applications/de.haeckerfelix.AudioSharing.desktop
export DEPLOY_OPENGL=1
export DEPLOY_GSTREAMER=1
export STARTUPWMCLASS=audio-sharing # For Wayland, this is 'de.haeckerfelix.AudioSharing', so this needs to be changed in desktop file manually by the user in that case until some potential automatic fix exists for this
export LOCALE_FIX=1 # Fixes crash when it fails to switch libc locale in alpine linux

# Trace and deploy all files and directories needed for the application (including binaries, libraries and others)
quick-sharun /usr/bin/audio-sharing

# Turn AppDir into AppImage
quick-sharun --make-appimage
