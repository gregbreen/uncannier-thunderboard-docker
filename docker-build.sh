#!/bin/bash

# Check that the Gecko SDK Suite version has been passed as an argument
if [ $# -ne 1 ]; then
	echo "Usage: $0 [Gecko SDK Suite Version Number. e.g. 2.4]"
	exit 1
fi

# Confirm that the Gecko SDK Suite version actually exists
if [ ! -d "/opt/SimplicityStudio_v4/developer/sdks/gecko_sdk_suite/v$1" ]; then
	echo "Gecko SDK Suite $1 not found in your Simplicity Studio installation"
	exit 1
fi

# Simplicity Studio does not support headless install of SDKs, so we
# copy our installation into the Docker context so we can build a
# Docker image with the necessary build tools
echo Copying Simplicity Studio installation to the Docker context ...
mkdir -p SimplicityStudio_v4
cp -R /opt/SimplicityStudio_v4 .

# Get rid of all SDKs except the one we currently need to build the Thunderboard projects
mv SimplicityStudio_v4/developer/sdks/gecko_sdk_suite/v$1 v$1
rm -r SimplicityStudio_v4/developer/sdks/gecko_sdk_suite/*
mv v$1 SimplicityStudio_v4/developer/sdks/gecko_sdk_suite/v$1

# Clean out other big things we don't need for CI of Thunderboard projects
rm -r SimplicityStudio_v4/developer/sdks/gecko_sdk_suite/v$1/app
rm -r SimplicityStudio_v4/developer/sdks/gecko_sdk_suite/v$1/hardware
rm -r SimplicityStudio_v4/developer/sdks/gecko_sdk_suite/v$1/platform/hwconf_data
rm -r SimplicityStudio_v4/developer/sdks/gecko_sdk_suite/v$1/util/third_party/emwin
rm -r SimplicityStudio_v4/p2/org.eclipse.equinox.p2.core/cache/binary

echo Running Docker build ...
docker build --tag gregbreen/uncannier-thunderboard:gecko-sdk-suite-v$1 .

echo Cleaning up ...
rm -r SimplicityStudio_v4

echo Push as "docker push gregbreen/uncannier-thunderboard:gecko-sdk-suite-v$1"

