# Verify WAMR
# Run the "test.c" app:
# cd ~/wasm-micro-runtime/samples/test/
# clang-8 --target=wasm32 -O3 -Wl,--initial-memory=131072,--allow-undefined,--export=main,--no-threads,--strip-all,--no-entry -nostdlib -o test.wasm test.c
# Pay attention to spacing above! ^
# iwasm test.wasm

# Verify Unikraft
# Run the "hello world" app:
# cd ~/apps/helloworld/
# make menuconfig
# Go to "Platform Configuration" and select `Linux user space` 
# Go to "Library Configuration" and select `ukschedcoop` and Save
# `make` to build and `./build/helloworld_linuxu-x86_64` to run

FROM ubuntu:latest

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y build-essential clang-8 cmake g++-multilib gdb git lib32gcc-5-dev libncurses-dev llvm-8 lld-8 nano

WORKDIR /root

# WebAssembly Micro Runtime (WAMR)

RUN git clone https://github.com/intel/wasm-micro-runtime

RUN cd wasm-micro-runtime/core/iwasm/products/linux/ && mkdir build && \
    cd build && cmake .. && make

RUN cd /usr/bin && ln -s wasm-ld-8 wasm-ld
RUN cd /usr/bin && ln -s ~/wasm-micro-runtime/core/iwasm/products/linux/build/iwasm iwasm

RUN mkdir /root/wasm-micro-runtime/samples/test
COPY test.c /root/wasm-micro-runtime/samples/test

# Unikraft

RUN mkdir apps && cd apps && \
    git clone https://xenbits.xen.org/git-http/unikraft/apps/helloworld.git

RUN mkdir libs && cd libs && \
    git clone https://xenbits.xen.org/git-http/unikraft/libs/newlib.git

RUN git clone https://xenbits.xen.org/git-http/unikraft/unikraft.git