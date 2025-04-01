#!/usr/bin/env bash
#ddev-generated
set -e

ARCH="$(uname -m)"

if [ "$ARCH" = "aarch64" ]; then
	ARCH="aarch64"
elif [ "$ARCH" = "x86_64" ]; then
	ARCH="x86-64"
fi

LOADER_BUNDLE="ioncube_loaders_lin_$ARCH.tar.gz"
LOADER_URL="https://downloads.ioncube.com/loader_downloads/$LOADER_BUNDLE"
OUTPUT_DIR="./web-build"
rm -rf "$OUTPUT_DIR/ioncube_loaders"*

if command -v aria2c &>/dev/null; then
	aria2c "$LOADER_URL" -d "$OUTPUT_DIR" >/dev/null
elif command -v wget &>/dev/null; then
	wget "$LOADER_URL" -P "$OUTPUT_DIR" >/dev/null
elif command -v curl &>/dev/null; then
	curl "$LOADER_URL" -o "$OUTPUT_DIR/$LOADER_BUNDLE" >/dev/null
else
	echo "None of the required downloaders (aria2c, wget, curl) are available."
	exit 1
fi

mv "$OUTPUT_DIR/$LOADER_BUNDLE" "$OUTPUT_DIR/ioncube_loaders.tar.gz"
