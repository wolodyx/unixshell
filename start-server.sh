set -e
docker build -t unixshell .
docker run --volume $(pwd):/book --rm unixshell

