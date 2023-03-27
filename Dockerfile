FROM ubuntu:latest

RUN apt update -y
RUN apt upgrade -y
RUN apt install -y nasm
RUN apt install -y qemu-system
RUN apt install -y build-essential

RUN apt install -y bison
RUN apt install -y flex
RUN apt install -y libgmp3-dev
RUN apt install -y libmpc-dev
RUN apt install -y libmpfr-dev
RUN apt install -y texinfo
RUN apt install -y gcc-multilib
RUN apt install -y curl

ARG PREFIX="/usr/local/i386elfgcc"
ARG TARGET=i386-elf
RUN echo 'export PATH="$PREFIX/bin:$PATH"' >> $HOME/.bashrc

RUN mkdir /tmp/src
RUN cd /tmp/src
RUN curl -O http://ftp.gnu.org/gnu/binutils/binutils-2.39.tar.gz
RUN tar xf binutils-2.39.tar.gz
RUN mkdir binutils-build
RUN cd binutils-build
RUN ../binutils-2.39/configure --target=$TARGET --enable-interwork --enable-multilib --disable-nls --disable-werror --prefix=$PREFIX 2>&1 | tee configure.log
RUN make all install 2>&1 | tee make.log

RUN cd /tmp/src
RUN curl -O https://ftp.gnu.org/gnu/gcc/gcc-12.2.0/gcc-12.2.0.tar.gz
RUN tar xf gcc-12.2.0.tar.gz
RUN mkdir gcc-build
RUN cd gcc-build
RUN make distclean
RUN ../gcc-12.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --disable-libssp --enable-language=c,c++ --without-headers
RUN make all-gcc
RUN make all-target-libgcc
RUN make install-gcc
RUN make install-target-libgcc

VOLUME /root/env
WORKDIR /root/env
