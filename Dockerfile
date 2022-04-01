FROM ubuntu:20.04

RUN echo "helloQleisan"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN apt-get install -y tig

COPY gcc-arm-11.2-2022.02-x86_64-arm-none-eabi /opt

ENV PATH="/opt/bin:${PATH}"

RUN apt-get install -y make

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Stockholm
RUN apt-get install -y tzdata

RUN apt-get install -y cmake

# this is a "gcc hello world" SDK...
COPY SDK_2_11_0_MK22FN512xxx12.tar.gz /home

RUN cd /home && tar -xvzf SDK_2_11_0_MK22FN512xxx12.tar.gz

ENV ARMGCC_DIR="/opt"
