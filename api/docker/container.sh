#!/usr/bin/env bash

#
# NOTE: used to test the container outside k8s
#

set +x
export DEBIAN_FRONTEND=noninteractive
# Absolute path to this repo
SCRIPT=$(readlink -f "$0")
export REPOPATH=$(dirname "$SCRIPT" | sed 's/\/api\/docker//g')

# what you can do
CLEAR=N
CLEANUP=N
BUILD=N
RUN=N
INTERACTIVE=N

# you can also set the flags using the command line
for var in "$@"
do
	if [ "CLEAR" == "$var" ]; then CLEAR=Y 
	fi
	if [ "CLEANUP" == "$var" ]; then CLEANUP=Y 
	fi
	if [ "BUILD" == "$var" ]; then BUILD=Y 
	fi
	if [ "RUN" == "$var" ]; then RUN=Y 
	fi
	if [ "INTERACTIVE" == "$var" ]; then INTERACTIVE=Y 
	fi
done

# clean up all containers
if [ "${CLEAR}" == "Y" ]; then
	sudo docker stop MODEL-API
	sudo docker kill MODEL-API
	sudo docker rm -f MODEL-API
	#sudo docker rm -f $(sudo docker ps -a | grep MODEL-API | awk '{ print $1 }')
fi

# clean up all images
if [ "${CLEANUP}" == "Y" ]; then
	$0 CLEAR
	sudo docker rmi -f model-api
fi

# create image
if [ "${BUILD}" == "Y" ]; then
	$0 CLEANUP
	sudo docker build $REPOPATH --rm=true -t model-api -f $REPOPATH/api/docker/dockerfile
fi

# run the container in the background
if [ "${RUN}" == "Y" ]; then
	$0 CLEAR
	#attached as a volume the model to use
	sudo docker run -d --name MODEL-API -p 80:80 -v $REPOPATH/model-registry:/model-registry model-api
fi

# run the container in the console
if [ "${INTERACTIVE}" == "Y" ]; then
	$0 CLEAR
	#sudo docker run -ti --name MODEL-API -p 80:80 -v $REPOPATH/data:/data \
	#	-v $REPOPATH/model-registry:/model-registry model-api /bin/bash

	#added the code folder as a volume for fast testing of code changes without rebuilding the container
	sudo docker run -ti --name MODEL-API -p 80:80 -v $REPOPATH/api/src:/src2 -v $REPOPATH/model-registry:/model-registry \
		model-api uvicorn src2.main:app --host 0.0.0.0 --port 80
fi
