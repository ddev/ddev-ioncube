#!/usr/bin/env bash
#ddev-generated

add_directives() {
    local FILE_PATH="$1"
    local PHP_VERSIONS=("5.6" "7.0" "7.1" "7.2" "7.3" "7.4" "8.1" "8.2" "8.3" "8.4")

    cat <<EOF >>"$FILE_PATH"
#ddev-generated
ARG TARGETARCH

RUN <<ENDIONCUBE
    set -eu -o pipefail
    ARCH="\${TARGETARCH}"
    if [ "\$ARCH" = "arm64" ]; then
        ARCH="aarch64"
    elif [ "\$ARCH" = "amd64" ]; then
        ARCH="x86-64"
    fi
    curl -L -o /tmp/ioncube_loaders.tar.gz https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_\$ARCH.tar.gz
    mkdir -p /etc/php/ioncube
    tar -zxvf /tmp/ioncube_loaders.tar.gz -C /etc/php/ioncube --strip-components=1
    rm -f /tmp/ioncube_loaders.tar.gz
    chown -R root:root /etc/php/ioncube
    rm -rf /etc/php/*/mods-available/ioncube.ini /etc/php/*/mods-available/00-ioncube.ini
ENDIONCUBE

EOF

    for VERSION in "${PHP_VERSIONS[@]}"; do
        printf "RUN printf \"zend_extension = /etc/php/ioncube/ioncube_loader_lin_%s.so%s; priority=0%s\" > /etc/php/%s/mods-available/00-ioncube.ini\n" "$VERSION" '\n' '\n' "$VERSION" >>"$FILE_PATH"
        if [[ "$VERSION" == "8.4" ]]; then
            # PHP Warning:  JIT is incompatible with third party extensions that setup user opcode handlers. JIT disabled. in Unknown on line 0
            printf "RUN printf \"# disable jit for ioncube%sopcache.jit=disable%s\" >> /etc/php/%s/mods-available/opcache.ini\n" '\n' '\n' "$VERSION" >>"$FILE_PATH"
        fi
    done

    cat <<EOF >>"$FILE_PATH"
RUN phpenmod 00-ioncube
EOF
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
