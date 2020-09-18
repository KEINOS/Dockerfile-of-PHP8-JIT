#!/usr/bin/env bash
# =============================================================================
#  Image Updater of Docker for PHP 8.0 w/Alpine Base Image
# =============================================================================
# This script checks the latest Alpine docker image version and updates the
# Docker images.
#
# NOTE:
#   - This script must run on local and only was tested with macOS(Mojave).
#   - Exits with a "0"(zero) staus if no update found.
#
# Update steps:
#   1. Pull alpine:latest image.
#   2. Gets the os-release version of the image above.
#   3. Compares the version between alpine:latest and keinos/alpine:latest.
#   4. Re-writes the version info of the Dockerfile.
#   5. Git add, commit and push if updated.

# -----------------------------------------------------------------------------
#  Functions
# -----------------------------------------------------------------------------

build_docker_for_smoke_test() {
  name_tag_test='test:local'
  echo '- Building test image'
  # The smoke test image will use the default source archive. This is defined
  # in Dockerfile
  docker system prune -a -f &&
    docker build -t $name_tag_test . &&
    update_php_info "$name_tag_test" &&
    update_php_modules "$name_tag_test" &&
    VERSION_PHP_NEW=$(get_version_php "$name_tag_test")
}

commit_push_git() {
  git status | grep 'nothing to commit' && {
    return 0
  }
  # Updating git
  echo '- GIT: Committing and pushing to GitHub ...'
  git add . &&
    git commit -m "feat: Alpine v${VERSION_OS_NEW} Build: ${ID_BUILD_NEW}" &&
    git tag --force "${TAG_RELEASED_NEW}" &&
    git push --force --tags &&
    git push --force origin
  [ $? -ne 0 ] && {
    echo >&2 '* Failed commit and push'
    exit 1
  }
}

get_version_alpine_latest() {
  docker pull keinos/alpine >/dev/null
  docker run --rm -i keinos/alpine cat /etc/os-release | grep VERSION_ID | sed -e 's/[^0-9\.]//g'
}

get_version_php() {
  name_image_tmp="${1:-$NAME_IMAGE_DOCKER_LATEST}"
  pull_image "$name_image_tmp"
  docker run --rm $name_image_tmp php -r 'echo phpversion();'
}

is_available() {
  which "$1" 2>/dev/null 1>/dev/null
  return "$?"
}

pull_image() {
  name_image_tmp="${1}"
  docker images | grep ${name_image_tmp/:*/} >/dev/null || {
    docker pull $name_image_tmp >/dev/null
  }
}

release_git() {
  tag_git_short=$(git rev-parse --short HEAD)
  tag_release="8.0.0-dev ($tag_git_short)"
  gh release create \
    "${TAG_RELEASED_NEW}" \
    "${PATH_DIR_SELF}/src/php.7z" \
    "${PATH_DIR_SELF}/src/php.7z.sig" \
    "${PATH_DIR_SELF}/id_rsa.pkcs8.pub" \
    --title "$tag_release" \
    --notes "${TAG_RELEASED_NEW}\nfeat: Alpine v${VERSION_OS_NEW} Build: ${ID_BUILD_NEW}"
}

update_info_build() {
  echo "Updating/over-writing ${NAME_FILE_BUILD_INFO}"
  cat <<EOL >$PATH_FILE_BUILD_INFO
VERSION_OS=${VERSION_OS_NEW}
VERSION_PHP=${VERSION_PHP_NEW}
ID_BUILD=${ID_BUILD_NEW}
ID_SRC_ARCHIVED=${ID_SRC_ARCHIVED_NEW}
TAG_RELEASED=${TAG_RELEASED_NEW}
EOL
}

update_php_info() {
  echo '- Updating PHP info file'
  name_image_tmp="${1:-$NAME_IMAGE_DOCKER_LATEST}"
  pull_image "$name_image_tmp"
  docker run --rm "${name_image_tmp}" php -i >$PATH_FILE_PHP_INFO
}

update_php_modules() {
  echo '- Updating PHP loaded modules'
  name_image_tmp="${1:-$NAME_IMAGE_DOCKER_LATEST}"
  pull_image "$name_image_tmp"
  docker run --rm "${name_image_tmp}" php -m >$PATH_FILE_EXT_INFO
}

update_src_archive() {
  ./_download-source.sh
}

# -----------------------------------------------------------------------------
#  Requirement check
# -----------------------------------------------------------------------------

is_available 'brew' || {
  echo >&2 'Homebrew must be installed.'
  exit 1
}
is_available 'docker' || {
  echo >&2 'Docker must be installed. Run: brew install docker'
  exit 1
}
is_available 'curl' || {
  echo >&2 'Curl must be installed. Run: brew install curl'
  exit 1
}
is_available '7z' || {
  echo >&2 '7zip must be installed. Run: brew install p7zip'
  exit 1
}
is_available 'unzip' || {
  echo >&2 'Unzip must be installed. Run: brew install unzip'
  exit 1
}
is_available 'openssl' || {
  echo >&2 'OpenSSL must be installed. Run: brew install openssl'
  exit 1
}
is_available 'gh' || {
  echo >&2 'GitHub CLI must be installed. Run: brew install gh'
  exit 1
}

# -----------------------------------------------------------------------------
#  Constants
# -----------------------------------------------------------------------------
NAME_FILE_BUILD_INFO='info-build.txt'
NAME_FILE_PHP_INFO='info-phpinfo.txt'
NAME_FILE_EXT_INFO='info-get_loaded_extensions.txt'
NAME_IMAGE_DOCKER_LATEST='keinos/php8-jit:latest'

VERSION_OS_NEW=$(get_version_alpine_latest)
VERSION_PHP_NEW=$(get_version_php)
ID_BUILD_NEW=$(date '+%Y%m%d')
ID_SRC_ARCHIVED_NEW=$(date '+%Y%m%d')
TAG_RELEASED_NEW="8.0.0-dev-build-${ID_BUILD_NEW}"

PATH_DIR_SELF=$(cd "$(dirname "${BASH_SOURCE:-$0}")" && pwd)
PATH_FILE_BUILD_INFO="${PATH_DIR_SELF:-.}/${NAME_FILE_BUILD_INFO}"
PATH_FILE_PHP_INFO="${PATH_DIR_SELF:-.}/${NAME_FILE_PHP_INFO}"
PATH_FILE_EXT_INFO="${PATH_DIR_SELF:-.}/${NAME_FILE_EXT_INFO}"

# -----------------------------------------------------------------------------
#  Setup
# -----------------------------------------------------------------------------
usage() {
  echo "usage: ${0} [OPTIONS]"
  echo
  echo "OPTIONS:"
  echo
  echo "  help   This help."
  echo "  force  Update even Alpine's version are the same."
  echo
}

update_force=0 # Force update by default: 0=no 1=yes
case "$1" in
  force)
    update_force=1
    ;;
  *)
    update_force=0
    ;;
esac

# Load current version info
source ./$NAME_FILE_BUILD_INFO

# Show current info
[ "$update_force" -ne 0 ] && { echo '- MODE: Force update'; }
echo '- Current Alpine version     :' ${VERSION_OS:-unknown} '-> Latest version:' ${VERSION_OS_NEW:-unknown}
echo '- Current PHP version        :' ${VERSION_PHP:-unknown}
echo '- Current build ID           :' ${ID_BUILD:-unknown}
echo '- Current GitHub release tag :' ${TAG_RELEASED:-unknown}
echo '- Current PHP source ID      :' ${ID_SRC_ARCHIVED:-unknown}

# Compare OS version
msg_update='Updataing ...'
[ "$update_force" -eq 0 ] && {
  [ "$VERSION_OS" = "$VERSION_OS_NEW" ] && {
    echo
    echo 'No update found. Do nothing.'
    echo
    usage
    exit 0
  }
  msg_update='Newer OS version of the base image found. Updating ...'
}

[ "$ID_SRC_ARCHIVED" = "${ID_SRC_ARCHIVED_NEW}" ] || {
  echo '---------------------------------------------------'
  echo ' Updating Archive of PHP Source'
  echo '---------------------------------------------------'
  echo ' Archived date did not match. Updating ...'

  update_src_archive || {
    exit 1
  }

  build_docker_for_smoke_test || {
    exit 1
  }

  update_info_build || {
    echo >&2 'Failed to update'
    exit 1
  }

  commit_push_git || {
    echo >&2 'Failed to commit/push'
    exit 1
  }

  release_git || {
    echo >&2 'Failed to release'
    exit 1
  }
}

# -----------------------------------------------------------------------------
#  Main (Update)
# -----------------------------------------------------------------------------
echo $msg_update

# Clear all the docker images and containers for stable build
echo -n '- Prune all ... '
docker system prune -f -a | tail -n1

# Build the images
echo '- Building Docker images for all architectures'
TAG_RELESED="${TAG_RELEASED_NEW}" ./_build-image.sh
[ $? -ne 0 ] && {
  echo >&2 "* Failed update: ${PATH_FILE_BUILD_INFO}"
  exit 1
}
echo "- Updated"

version_php=$(docker run --rm keinos/php8-jit:latest php -r 'echo phpversion();')
