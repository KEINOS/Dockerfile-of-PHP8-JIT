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
NAME_IMAGE_DOCKER='keinos/alpine'
BUILD_ID_CURRENT=$(date '+%Y%m%d')

# Displays Docker Version info to see Docker Cloud Architecture
docker version

# Load current version info
source ./$PATH_FILE_VER_INFO
echo '- Current version:' ${VERSION_ID:-unknown}
echo '- Current build ID:' ${BUILD_ID:-unknown}

# Clear all the docker images
docker system prune -f -a

# Pull latest Alpine image
docker pull alpine:latest > /dev/null

# Fetch the latest Alpine version
VERSION_NEW=$(docker run --rm -i alpine:latest cat /etc/os-release | grep VERSION_ID | sed -e 's/[^0-9\.]//g')
echo '- Latest version:' $VERSION_NEW

# Compare
if [ $VERSION_ID = $VERSION_NEW ] && [ $BUILD_ID = $BUILD_ID_CURRENT ]; then
   echo 'No update found. Do nothing.'
   exit 1
fi

#  Update
# --------
echo 'Newer version found. Updating ...'

# Updating VERSION_IMAGE_BASE.txt
echo -e "VERSION_ID=${VERSION_NEW}\nBUILD_ID=${BUILD_ID}" > ./$PATH_FILE_VER_INFO
./build-image.sh
if [ $? -ne 0 ]; then
  echo "* Failed update: ${PATH_FILE_VER_INFO}"
  exit 1
fi
echo "- Updated"

# Updating git
echo 'GIT: Committing and pushing to GitHub ...'
git add . && \
git commit -m "feat: Alpine v${VERSION_NEW} Build: ${BUILD_ID}" && \
git tag "v${VERSION_NEW}(Build:${BUILD_ID})" && \
git push --tags && \
git push origin
if [ $? -ne 0 ]; then
  echo '* Failed commit and push'
  exit 1
fi
echo "- Pushed: GitHub"