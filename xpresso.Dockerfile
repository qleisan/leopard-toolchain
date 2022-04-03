FROM ubuntu:20.04

RUN apt-get update && \
    apt-get upgrade -y

COPY gcc-arm-11.2-2022.02-x86_64-arm-none-eabi /opt

ENV PATH="/opt/bin:${PATH}"
ENV ARMGCC_DIR="/opt"

RUN apt-get install -y make

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Stockholm
RUN apt-get install -y tzdata

RUN apt-get install -y cmake

COPY mcuxpressoide-11.5.0_7232.x86_64.deb.bin /home

WORKDIR  /home

RUN chmod a+x /home/mcuxpressoide-11.5.0_7232.x86_64.deb.bin &&\
    ./mcuxpressoide-11.5.0_7232.x86_64.deb.bin --noexec --target mcu
