#!/bin/bash

# For local running and testing of the docker container
docker run --rm -it \
	--name uncannier-thunderboard \
	--volume /home/uncannier/Desktop/Projects/uncannier-thunderboard-react:/uncannier-thunderboard-react \
	--volume /home/uncannier/Desktop/Projects/uncannier-thunderboard-sense2:/uncannier-thunderboard-sense2 \
	gregbreen/uncannier-thunderboard:gecko-sdk-suite-v$1
