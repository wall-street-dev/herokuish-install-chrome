#!/bin/bash

# Helper function to display errors
function error() {
  echo " !     $*" >&2
  exit 1
}

# Helper function to display information messages
function message() {
  echo "-----> $*"
}

function downloadChrome() {
  # HEROKU paths
  BUILD='/tmp/build'
  CACHE='/tmp/cache'
  ENV='/tmp/env'
  CHROME_BUILDPACK='/tmp/buildpacks/99_buildpack-chrome/bin'

  # Prepare destination folder for download
  mkdir -p $CHROME_BUILDPACK
  # Download latest master compile definition from Official Heroku repo
  curl https://raw.githubusercontent.com/heroku/heroku-buildpack-google-chrome/master/bin/compile --output $CHROME_BUILDPACK/compile
  # Ensure run permissions
  chmod +x $CHROME_BUILDPACK/compile
  # Run the downloaded script and export the CHROME_BIN on success only
  # (notice how the BUILD, CACHE and ENV are passed to the compile script)
  if $CHROME_BUILDPACK/compile $BUILD $CACHE $ENV; then
    export CHROME_BIN=$GOOGLE_CHROME_SHIM
    message "Chrome is ready"
    exit 0
  else
    error "Error downloading Chrome"
  fi
}

# This script should run on TEST only
if [ "$NODE_ENV" == "test" ]; then
  message "NODE_ENV is TEST. Chrome download should start in a few seconds..."
  downloadChrome
fi
