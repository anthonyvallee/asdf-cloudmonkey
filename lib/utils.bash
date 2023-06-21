#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/apache/cloudstack-cloudmonkey"
TOOL_NAME="cloudmonkey"
EXECUTABLE_NAME="cmk"
TOOL_TEST="cmk version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# TODO: Adapt this. By default we simply list the tag names from GitHub releases.
	# Change this function if cloudmonkey has other means of determining installable versions.
	list_github_tags
}

get_arch() {
  local arch
  arch="$(uname -m)"

  case $arch in
  amd64 | x86_64)
    echo "x86-64"
    ;;
  arm64)
    echo "arm64"
    ;;
  arm32)
    echo "arm32"
    ;;
  *)
    echo ""
    ;;
  esac
}

get_platform() {
  [ "Linux" = "$(uname)" ] && echo "linux" || echo "darwin"
}

download_release() {
	local version filename asset url
	version="$1"
	filename="$2"

  arch=$(get_arch)
  if [ -z "$arch" ]; then
    fail "Unsupported architecture: $arch"
  fi
  echo "Detected architecture: $arch"

  platform=$(get_platform)
  if [ -z "$platform" ]; then
    fail "Unsupported platform: $platform"
  fi
  echo "Detected platform: $platform"

	asset="cmk.${platform}.${arch}"
	url="$GH_REPO/releases/download/${version}/${asset}"

	echo "* Downloading $TOOL_NAME release $version..."
	echo "* Fetching release asset ${asset} on GitHub..."

	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		chmod +x "$install_path/$EXECUTABLE_NAME"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
