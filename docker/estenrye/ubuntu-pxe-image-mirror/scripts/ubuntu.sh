#!/bin/bash

fatal() {
  echo "$1"
  exit 1
}

warn() {
  echo "$1"
}

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

${SCRIPT_DIR}/date-script.sh || fatal "Failed to run date-script.sh."
${SCRIPT_DIR}/rsync.ubuntu.sh || fatal "Failed to rsync from ${RSYNCSOURCE}."
${SCRIPT_DIR}/extract.ubuntu.sh || fatal "Failed to extract from ${RSYNCSOURCE}."
