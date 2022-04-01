FROM ubuntu:20.04

RUN echo "helloQleisan"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN apt-get install -y tig

COPY gcc-arm-11.2-2022.02-x86_64-arm-none-eabi /opt

ENV PATH="/opt/bin:${PATH}"

RUN apt install make