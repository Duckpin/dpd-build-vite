#!/bin/bash
# If any commands fail (exit code other than 0) entire script exits
set -e

# See if our project has a gulpfile either in the root directory if it's a theme
# or in the assets/ folder if it is a plugin

composer_path="./composer.json"
package_path="./package.json"
build_file_path="./vite.config.js"
bower_file_path="./bower.json"
build_type=none

# Begin from the ~/clone directory
# this directory is the default your git project is checked out into by Codeship.
cd ~/clone

# If we have composer dependencies make sure they are installed
if [ -f "$composer_path" ]
then
	echo "Composer File found. Starting composer install."
	composer install
fi

if [ -f "$build_file_path" ]
then
	echo "Vite file found. Starting build process"
	build_type=vite
fi

# check to see our build type and if so build using either gulp or grunt
if [ "$build_type" == "vite" ]
then
	echo "Initiating NPM Install"
	npm install
	if grep -q build:production "$build_file_path";
	then
		echo "Building project using gulp"
		gulp build:production
	fi
fi
