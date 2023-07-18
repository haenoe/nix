#!/usr/bin/env bash

set -eu -o pipefail

set -x

source common.sh

# Avoid store dir being inside sandbox build-dir
unset NIX_STORE_DIR
unset NIX_STATE_DIR

storeDirs

initLowerStore

mountOverlayfs

# Add something to the overlay store
overlayPath=$(addTextToStore "$storeB" "overlay-file" "Add to overlay store")
stat "$TEST_ROOT/merged-store/$overlayPath"

# Now add something to the lower store
lowerPath=$(addTextToStore "$storeA" "lower-file" "Add to lower store")
stat "$TEST_ROOT/store-a/$lowerPath"

# Remount overlayfs to ensure synchronization
mount -o remount "$TEST_ROOT/merged-store/nix/store"

# Path should be accessible via overlay store
stat "$TEST_ROOT/merged-store/$lowerPath"
