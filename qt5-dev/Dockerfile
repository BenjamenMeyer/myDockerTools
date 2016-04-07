# Base Environment
FROM ubuntu:15.10

# Description
MAINTAINER Benjamen R. Meyer
LABEL description="Docker Image for Qt5 Development"
LABEL version="Ubuntu-15.04"

# Update it to latest
RUN apt-get -y update && apt-get -y upgrade

# Build Essentials
RUN apt-get -y install build-essential git perl python

# Libxcb Requirements
RUN apt-get -y install "^libxcb.*" libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev
# Accessibility
RUN apt-get -y install libatspi2.0-dev libdbus-1-dev

# Qt WebKit
RUN apt-get -y install flex bison gperf libicu-dev libxslt-dev ruby
# Qt WebEngine
RUN apt-get -y install libssl-dev libxcursor-dev libxcomposite-dev libxdamage-dev libxrandr-dev libfontconfig1-dev
# Qt Multimedia
RUN apt-get -y install libasound2-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev

# Editor Environment
RUN apt-get -y install vim.nox
# User Environment
RUN apt-get -y install sudo

# Default UID/GID are 1000/1000; modify if your user or user's group differ
RUN useradd -m -U qt5-developer && echo "PATH=${PATH}:~/.bin" >> /home/qt5-developer/.bashrc

# Enable the user to use sudo without password
RUN usermod -a -G sudo qt5-developer
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Entry Point...
USER qt5-developer
WORKDIR /home/qt5-developer
ENTRYPOINT exec /bin/bash -l
