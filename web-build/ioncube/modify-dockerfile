#!/usr/bin/env bash
#ddev-generated

remove_directives() {
	local FILE_PATH="$1"
	TMP_FILE="$(mktemp)"

	between_markers=false

	# Loop through the lines of the file
	while IFS= read -r LINE; do

		# Check if the line contains the "BEGIN IonCube Install" marker
		if [[ $LINE == "# BEGIN IonCube Install" ]]; then
			between_markers=true
			continue
		fi

		# Check if the line contains the "END IonCube Install" marker
		if [[ $LINE == "# END IonCube Install" ]]; then
			between_markers=false
			continue
		fi

		# If we're not between markers, write the line to the temporary file
		if [ "$between_markers" == false ]; then
			echo "$LINE" >>"$TMP_FILE"
		fi

	done <"$FILE_PATH"

	# Overwrite the original file with the temporary file
	mv "$TMP_FILE" "$FILE_PATH"
}

add_directives() {
	local FILE_PATH="$1"
	local PHP_VERSIONS=("5.6" "7.0" "7.1" "7.2" "7.3" "7.4" "8.1" "8.2")

	cat <<EOF >>"$FILE_PATH"
# BEGIN IonCube Install
ADD ioncube_loaders.tar.gz /etc/php

RUN chown -R root:root /etc/php/ioncube
RUN rm -rf /etc/php/*/mods-available/ioncube.ini /etc/php/*/mods-available/00-ioncube.ini
EOF

	for VERSION in "${PHP_VERSIONS[@]}"; do
		printf "RUN printf \"zend_extension = /etc/php/ioncube/ioncube_loader_lin_%s.so%s; priority=0\" > /etc/php/%s/mods-available/00-ioncube.ini\n" "$VERSION" '\n' "$VERSION" >>"$FILE_PATH"
	done

	cat <<EOF >>"$FILE_PATH"
RUN phpenmod 00-ioncube
# END IonCube Install
EOF
}

# Define the file path
DOCKERFILE="web-build/Dockerfile.ioncube"
OLD_PATH="web-build/Dockerfile"

if [ -e "$OLD_PATH" ]; then
	remove_directives "$OLD_PATH"
fi

if [ -e "$DOCKERFILE" ]; then
	remove_directives "$DOCKERFILE"
	add_directives "$DOCKERFILE"
else
	add_directives "$DOCKERFILE"
fi
