FROM debian:10.1-slim

LABEL maintainer="Marius Reimer <reime005@gmail.com>"

RUN apt-get update -qq
RUN apt-get install -qqy python2.7 git x11-apps gcc make build-essential autoconf automake libgtk2.0-dev libglu1-mesa-dev libsdl1.2-dev libglade2-dev gettext zlib1g-dev libosmesa6-dev intltool libagg-dev libasound2-dev libsoundtouch-dev libpcap-dev

WORKDIR /usr/src/
RUN git clone https://github.com/emscripten-core/emsdk.git emsdk
COPY . /usr/src/emsdk/
WORKDIR /usr/src/emsdk/

# Download and install the latest SDK tools.
RUN ./emsdk install latest

# Make the "latest" SDK "active" for the current user. (writes ~/.emscripten file)
RUN ./emsdk activate latest

# Activate PATH and other environment variables
# TODO: make use of ./emsdk_env.sh script...
ENV PATH="/usr/src/emsdk/:${PATH}"
ENV PATH="/usr/src/emsdk/fastcomp/emscripten:${PATH}"
ENV PATH="/usr/src/emsdk/node/12.9.1_64bit/bin:${PATH}"

# Verify installation
RUN emcc test.c -Os -s WASM=1 -s SIDE_MODULE=1 -o hello_world.wasm
