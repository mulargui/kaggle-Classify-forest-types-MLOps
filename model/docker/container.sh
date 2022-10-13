#!/usr/bin/env bash

#
# NOTE: used to test the container outside k8s
#

set +x
export DEBIAN_FRONTEND=noninteractive
# Absolute path to this repo
SCRIPT=$(readlink -f "$0")
export REPOPATH=$(dirname "$SCRIPT" | sed 's/\/model\/docker//g')

# what you can do
CLEAR=N
CLEANUP=N
BUILD=N
MODEL=N
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
	if [ "MODEL" == "$var" ]; then MODEL=Y 
	fi
	if [ "RUN" == "$var" ]; then RUN=Y 
	fi
	if [ "INTERACTIVE" == "$var" ]; then INTERACTIVE=Y 
	fi
done

# clean up all containers
if [ "${CLEAR}" == "Y" ]; then
	sudo docker stop MODEL-BUILDER
	sudo docker kill MODEL-BUILDER
	sudo docker rm -f MODEL-BUILDER
	#sudo docker rm -f $(sudo docker ps -a | grep MODEL-BUILDER | awk '{ print $1 }')
fi

# clean up all images
if [ "${CLEANUP}" == "Y" ]; then
	$0 CLEAR
	sudo docker rmi -f model-builder
fi

# create image
if [ "${BUILD}" == "Y" ]; then
	$0 CLEANUP
	sudo docker build $REPOPATH --rm=true -t model-builder -f $REPOPATH/model/docker/dockerfile
fi

# run the container in the foreground
if [ "${MODEL}" == "Y" ]; then
	$0 CLEAR
	#we attach to the container as a volume the training data and where to export the model
	sudo docker run --name MODEL-BUILDER -p 80:80 -v $REPOPATH/data:/data \
		-v $REPOPATH/model-registry:/model-registry model-builder
fi

# run the container in the background
if [ "${RUN}" == "Y" ]; then
	$0 CLEAR
	#we attach to the container as a volume the training data and where to export the model
	sudo docker run -d --name MODEL-BUILDER -p 80:80 -v $REPOPATH/data:/data \
		-v $REPOPATH/model-registry:/model-registry model-builder
fi

# run the container in the console
if [ "${INTERACTIVE}" == "Y" ]; then
	$0 CLEAR
	#sudo docker run -ti --name MODEL-BUILDER -p 80:80 -v $REPOPATH/data:/data \
	#	-v $REPOPATH/model-registry:/model-registry model-builder /bin/bash

	#added the code folder as a volume for fast testing of code changes without rebuilding the container
	sudo docker run -ti --name MODEL-BUILDER -p 80:80 -v $REPOPATH/model/src:/src2 \
		-v $REPOPATH/data:/data -v $REPOPATH/model-registry:/model-registry \
		model-builder python3 src2/main.py
fi
