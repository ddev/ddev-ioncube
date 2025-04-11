#!/usr/bin/env bash
#ddev-generated

add_directives() {
	local FILE_PATH="$1"
	local PHP_VERSIONS=("5.6" "7.0" "7.1" "7.2" "7.3" "7.4" "8.1" "8.2" "8.3" "8.4")

	cat <<EOF >>"$FILE_PATH"
# BEGIN IonCube Install
ADD ioncube_loaders.tar.gz /etc/php

RUN chown -R root:root /etc/php/ioncube
RUN rm -rf /etc/php/*/mods-available/ioncube.ini /etc/php/*/mods-available/00-ioncube.ini
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
# END IonCube Install
EOF
}

# Define the file path
DOCKERFILE="web-build/Dockerfile.ioncube"

if [ -e "$DOCKERFILE" ]; then
	rm -f "$DOCKERFILE" >/dev/null
fi

add_directives "$DOCKERFILE"
