#!/bin/bash

# Look up the DOCKER_*  name of a HOST_* variable
function getDockerVariableName()
{
	local HOST_VAR_NAME=${1}
	local DOCKER_VAR_NAME="${HOST_VAR_NAME//HOST_/DOCKER_}"
	echo ${DOCKER_VAR_NAME}
}

# Look up a variable value given it's name
function getVariableValue()
{
	local VAR_NAME=${1}
	local VAR_VALUE=`env | grep ${VAR_NAME} | cut -f 2 -d '='`
	echo ${VAR_VALUE}
}

# List the Volumes to mount
function showDockerVolumeMounts()
{
	local PREFIX="${1}"
	local VOLUME_MOUNTS=""
	for HOST_VAR in `env | grep MOUNT_HOST | cut -f 1 -d '='`
	do
		local DOCKER_VAR=$(getDockerVariableName ${HOST_VAR})
		echo "${PREFIX}$(getVariableValue ${HOST_VAR}) -> $(getVariableValue ${DOCKER_VAR})"
	done
}

# Build the mount variable
function getDockerVolumesToMount()
{
	local VOLUME_MOUNTS=""
	for HOST_VAR in `env | grep MOUNT_HOST | cut -f 1 -d '='`
	do
		local DOCKER_VAR=$(getDockerVariableName ${HOST_VAR})
		VOLUME_MOUNTS="${VOLUME_MOUNTS} -v $(getVariableValue ${HOST_VAR}):$(getVariableValue ${DOCKER_VAR})"
	done
	echo ${VOLUME_MOUNTS}
}

###########################
# Host Configuration Data #
###########################
HOST_VOLUMES="${HOME}/.docker-volumes"

#############################
# Docker Configuration Data #
#############################
DOCKER_USER="qt5-developer"
DOCKER_USER_HOME="/home/${DOCKER_USER}"

###################
# Mounted Volumes #
###################
# Note: Trick here is that the variables must be "exported"
# 	for getDockerVolumesToMount() and showDockerVolumeMounts()
#	to find the variables

# Shell Tools
export MOUNT_HOST_SHELL_TOOLS="${HOST_VOLUMES}/shell-tools"
export MOUNT_DOCKER_SHELL_TOOLS="${DOCKER_USER_HOME}/.bin"

# SSH Configuration Environment
export MOUNT_HOST_SSH_ENV="${HOME}/.ssh"
export MOUNT_DOCKER_SSH_ENV="${DOCKER_USER_HOME}/.ssh"

# Qt5 Dev Environment Volume
export MOUNT_HOST_DEV_ENV="${HOST_VOLUMES}/qt5-dev"
export MOUNT_DOCKER_DEV_ENV="${DOCKER_USER_HOME}/qt5-dev"

# Get the Docker command-line for mounting the volumes
VOLUMES_TO_MOUNT="$(getDockerVolumesToMount)"

#####################################
# Dump host data to for user to see #
#####################################
echo "Host:"
echo "	Volume Location: ${HOST_VOLUME_LOCATION}"

#####################################
# Dump mapping data for user to see #
#####################################
echo "Mappings:"

# Dump the mapping and convert to a single variable for easy
echo "	Volumes to Mount:"
showDockerVolumeMounts "		"

###################################################
# Dump the docker system data for the user to see #
###################################################
echo "Docker System:"
echo "	User: ${DOCKER_USER}"
echo "	Volume Mount Targets: ${VOLUMES_TO_MOUNT}"

##################################
# Run the docker container/image #
##################################
# Note: This leaves the user in a new user-shell with the full bash profile loaded
# Hint: Setup the shell so that the user's UID and GID match your own, image provded
#	has UID/GID = 1000/1000
sudo docker run ${VOLUMES_TO_MOUNT} -it qt5-dev-env:ubuntu-15.04
