#!/bin/bash

## pyenv configs
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:/usr/local/bin:${HOME}/.krew/bin:$PATH"

if [ -d /kube ]; then
  KUBE_CONFIG_FILES=`find /kube -type f`

  for f in $KUBE_CONFIG_FILES
  do
    export KUBECONFIG=${KUBECONFIG:+$KUBECONFIG:}$f
  done
fi

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
