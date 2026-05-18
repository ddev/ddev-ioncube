#!/usr/bin/env bash
#ddev-generated

add_directives() {
 local FILE_PATH="$1"

 cat <<'ENDDOCKERFILE' >>"$FILE_PATH"
#ddev-generated
#ddev-silent-no-warn
ARG TARGETARCH

RUN <<ENDIONCUBE
  set -eu -o pipefail
  ARCH="${TARGETARCH}"
  if [ "$ARCH" = "arm64" ]; then
    ARCH="aarch64"
  elif [ "$ARCH" = "amd64" ]; then
    ARCH="x86-64"
  fi
  curl -L -o /tmp/ioncube_loaders.tar.gz https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_${ARCH}.tar.gz
  mkdir -p /etc/php/ioncube
  tar -zxvf /tmp/ioncube_loaders.tar.gz -C /etc/php/ioncube --strip-components=1
  rm -f /tmp/ioncube_loaders.tar.gz
  chown -R root:root /etc/php/ioncube
  rm -rf /etc/php/*/mods-available/ioncube.ini /etc/php/*/mods-available/00-ioncube.ini
  for SO_FILE in /etc/php/ioncube/ioncube_loader_lin_*.so; do
    VERSION=$(basename "$SO_FILE" .so | sed 's/ioncube_loader_lin_//')
    if [ -d "/etc/php/$VERSION" ]; then
      printf "zend_extension = /etc/php/ioncube/ioncube_loader_lin_%s.so\n; priority=0\n" "$VERSION" > "/etc/php/$VERSION/mods-available/00-ioncube.ini"
      # PHP Warning: JIT is incompatible with third party extensions that setup user opcode handlers. JIT disabled. in Unknown on line 0
      if [ "$VERSION" = "8.4" ]; then
        printf "# disable jit for ioncube\nopcache.jit=disable\n" >> "/etc/php/$VERSION/mods-available/opcache.ini"
      fi
    fi
  done
  phpenmod 00-ioncube
ENDIONCUBE
ENDDOCKERFILE
}

# Define the file path
DOCKERFILE="web-build/Dockerfile.ioncube"

if [ -e "$DOCKERFILE" ]; then
  rm -f "$DOCKERFILE" >/dev/null
fi

add_directives "$DOCKERFILE"

# Remove leftovers from previous add-on versions
# And remove this script itself
rm -rf "web-build/ioncube"* >/dev/null
