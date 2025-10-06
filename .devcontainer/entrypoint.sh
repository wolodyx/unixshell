#!/bin/bash
set -e

if [ ! -f _config.yml ]; then
  echo "sudo docker run --volume \$(pwd):/book --rm unixshell"
  exit 1
fi

if [ -d _build ]; then
  rm -rf _build
fi

jupyter-book build --all --builder html .

exec "$@"

