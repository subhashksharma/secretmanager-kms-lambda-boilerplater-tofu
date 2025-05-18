#!/bin/zsh
# Script to package all Lambda functions as zip files for deployment, including dependencies

set -e
LAMBDA_DIR="lambdas"
DIST_DIR="dist"

mkdir -p $DIST_DIR

for fn in $LAMBDA_DIR/*; do
  if [ -d "$fn" ]; then
    fname=$(basename $fn)
    # If requirements.txt exists, install dependencies into a temp build dir
    if [ -f "$fn/requirements.txt" ]; then
      rm -rf "$fn/build"
      mkdir "$fn/build"
      pip install -r "$fn/requirements.txt" -t "$fn/build"
      cp "$fn"/*.py "$fn/build/"
      (cd "$fn/build" && zip -r "../../../$DIST_DIR/${fname}.zip" . > /dev/null)
      rm -rf "$fn/build"
      echo "Packaged $fname with dependencies as $DIST_DIR/${fname}.zip"
    else
      (cd "$fn" && zip -r "../../$DIST_DIR/${fname}.zip" . > /dev/null)
      echo "Packaged $fname as $DIST_DIR/${fname}.zip (no dependencies)"
    fi
  fi
done
