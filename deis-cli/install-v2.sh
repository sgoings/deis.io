#!/usr/bin/env bash

# Invoking this script:
#
# curl https://deis.io/deis-cli/install-v2.sh | sh
#
# - download deis file
# - making sure deis is executable
# - explain what was done
#

set -eo pipefail -o nounset

function check_platform_arch {
  local supported="linux-amd64 darwin-amd64"

  if ! echo "${supported}" | tr ' ' '\n' | grep -q "${PLATFORM}-${ARCH}"; then
    cat <<EOF

${PROGRAM} is not currently supported on ${PLATFORM}-${ARCH}.

See https://github.com/deis/workflow for more information.

EOF
  fi
}

function get_latest_version {
  local url="${1}"
  local version
  version="$(curl -sI "${url}" | grep "Location:" | sed -n 's%.*deis/%%;s%/view.*%%p' )"

  if [ -z "${version}" ]; then
    echo "There doesn't seem to be a version of ${PROGRAM} avaiable at ${url}." 1>&2
    return 1
  fi

  url_decode "${version}"
}

function url_decode {
  local url_encoded="${1//+/ }"
  printf '%b' "${url_encoded//%/\\x}"
}

PROGRAM="deis"
PLATFORM="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"
# https://storage.googleapis.com/workflow-cli/v2.0.0/deis-v2.0.0-darwin-386
DEIS_BIN_URL_BASE="https://storage.googleapis.com/workflow-cli"

if [ "${ARCH}" == "x86_64" ]; then
  ARCH="amd64"
fi

check_platform_arch

VERSION="v2.1.0"
FOLDER=${VERSION}
DEIS_CLI="deis-${VERSION}-${PLATFORM}-${ARCH}"

echo "Downloading ${DEIS_CLI} From Google Cloud Storage..."
curl -Ls -o deis "${DEIS_BIN_URL_BASE}/${FOLDER}/${DEIS_CLI}"

chmod +x deis

cat <<EOF

${PROGRAM} is now available in your current directory.

To learn more about deis, execute:

    $ ./deis --help

EOF
