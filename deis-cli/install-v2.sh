#!/usr/bin/env bash

# Invoking this script:
#
# To install the latest stable version:
# curl http://deis.io/deis-cli/install-v2.sh | bash
#
# To install a specific released version ($VERSION):
# curl http://deis.io/deis-cli/install-v2.sh | bash -x -s $VERSION
#
# - download deis file
# - making sure deis is executable
# - explain what was done
#

# install current version unless overridden by first command-line argument
VERSION=${1:-stable}

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

PROGRAM="deis"
PLATFORM="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"
# https://storage.googleapis.com/workflow-cli-release/v2.0.0/deis-v2.0.0-darwin-386
DEIS_BIN_URL_BASE="https://storage.googleapis.com/workflow-cli-release"

if [ "${ARCH}" == "x86_64" ]; then
  ARCH="amd64"
fi

check_platform_arch

DEIS_CLI="deis-${VERSION}-${PLATFORM}-${ARCH}"
DEIS_CLI_PATH="${DEIS_CLI}"
if [ "${VERSION}" != 'stable' ]; then
  DEIS_CLI_PATH="${VERSION}/${DEIS_CLI_PATH}"
fi

echo "Downloading ${DEIS_CLI} From Google Cloud Storage..."
curl -fsSL -o deis "${DEIS_BIN_URL_BASE}/${DEIS_CLI_PATH}"

chmod +x deis

cat <<EOF

${PROGRAM} is now available in your current directory.

To learn more about deis, execute:

    $ ./deis --help

EOF
