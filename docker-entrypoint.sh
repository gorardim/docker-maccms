#!/bin/sh
set -eu

# Check if index.php exists, if not, clone the repo
if [ ! -f index.php ]; then
    # Ensure /var/www/html is not a git repository
    if [ -d .git ]; then
        rm -rf .git  # Remove any existing git repository remnants
    fi

    git clone --recursive --depth 1 -q ${REPO_URL} .  # Clone the repo with submodules
    rm -rf .git*  # Remove .git to avoid git-related issues inside container
    chmod a+rw -R application runtime upload static addons
    echo "maccms and submodules downloaded"
fi

# If admin.php exists, rename it as defined in ENV variable ADMIN_PHP
if [ -f admin.php ]; then
    mv admin.php $ADMIN_PHP
    echo "admin.php => $ADMIN_PHP"
fi

exec "$@"