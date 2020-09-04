#!/usr/bin/env bash

# This script checks the latest Alpine docker image version.
#
# Exits with a "1"(false) staus if no update found. If found, it will update
# the keinos/alpine:latest and version tags and exits with a status "0"(true).
#
# NOTE: This script must run on local and only was tested with macOS(Mojave).
#
# Update steps:
#   1. Pull alpine:latest image.
#   2. Gets the os-release version of the image above.
#   3. Compares the version between alpine:latest and keinos/alpine:latest.
#   4. Re-writes the version info of the Dockerfile.
#   5. Git add, commit and push if updated.

# Define Basic Variables
PATH_FILE_VER_INFO='VERSION_IMAGE_BASE.txt'
PATH_FILE_PHP_INFO='info-phpinfo.txt'
PATH_FILE_EXT_INFO='info-get_loaded_extensions.txt'
NAME_IMAGE_DOCKER_LATEST='keinos/php8-jit:latest'
BUILD_ID=$(date '+%Y%m%d')

usage() {
  echo "Options"
  echo
  echo "  help   This help."
  echo "  force  Update even Alpine's version are the same."
  echo
}

update_force=
case "$1" in
force)
  update_force=1
  ;;
*)
  update_force=0
  ;;
esac

# Displays Docker Version info to see them in Docker Cloud
docker version

# Load current version info
source ./$PATH_FILE_VER_INFO
echo '- Current version:' ${VERSION_ID:-unknown}
echo '- Current build ID:' ${BUILD_ID:-unknown}

# Clear all the docker images and containers for stable build
docker system prune -f -a

# Pull latest Alpine image
docker pull alpine:latest >/dev/null

# Fetch the latest Alpine version
VERSION_NEW=$(docker run --rm -i alpine:latest cat /etc/os-release | grep VERSION_ID | sed -e 's/[^0-9\.]//g')
echo '- Latest version:' $VERSION_NEW

[ "$update_force" -ne 0 ] && {
  msg_update='Updataing ...'
} || {
  # Compare
  if [ $VERSION_ID = $VERSION_NEW ]; then
    echo 'No update found. Do nothing.'
    usage
    exit 0
  else
    msg_update='Newer version found. Updating ...'
  fi
}

# -----------------------------------------------------------------------------
#  Update
# -----------------------------------------------------------------------------
echo $msg_update

# Updating VERSION_IMAGE_BASE.txt
echo -e "VERSION_ID=${VERSION_NEW}\nBUILD_ID=${BUILD_ID}" >./$PATH_FILE_VER_INFO
./build-image.sh
[ $? -ne 0 ] && {
  echo >&2 "* Failed update: ${PATH_FILE_VER_INFO}"
  exit 1
}
echo "- Updated"

# Updating phpinfo results
docker run --rm $NAME_IMAGE_DOCKER_LATEST php -i >./$PATH_FILE_PHP_INFO

# Updating loaded extension modules by default
docker run --rm $NAME_IMAGE_DOCKER_LATEST php -m >./$PATH_FILE_EXT_INFO

varsion_php=$(docker run --rm keinos/php8-jit:latest php -r 'echo phpversion();')

# Updating git
echo 'GIT: Committing and pushing to GitHub ...'
git add . &&
  git commit -m "feat: Alpine v${VERSION_NEW} Build: ${BUILD_ID}" &&
  git tag "${varsion_php:-8.0.0-dev}-build-${BUILD_ID}" &&
  git push --tags &&
  git push origin
[ $? -ne 0 ] && {
  echo >&2 '* Failed commit and push'
  exit 1
}
echo "- Pushed: GitHub"
