FROM ubuntu:latest

RUN apt update -y
RUN apt upgrade -y
RUN apt install -y nasm
RUN apt install -y qemu-system
RUN apt install -y build-essential

VOLUME /root/env
WORKDIR /root/env
