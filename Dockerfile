FROM ubuntu:20.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

# install gcc 
COPY gcc-arm-11.2-2022.02-x86_64-arm-none-eabi.tar.xz /opt
RUN apt-get install -y xz-utils
RUN cd /opt && tar -xf gcc-arm-11.2-2022.02-x86_64-arm-none-eabi.tar.xz && rm gcc-arm-11.2-2022.02-x86_64-arm-none-eabi.tar.xz
ENV PATH="/opt/gcc-arm-11.2-2022.02-x86_64-arm-none-eabi/bin:${PATH}"
ENV ARMGCC_DIR="/opt/gcc-arm-11.2-2022.02-x86_64-arm-none-eabi"

# install make
RUN apt-get install -y make

# install cmake
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Stockholm
RUN apt-get install -y tzdata
RUN apt-get install -y cmake

# install SDK
COPY SDK_2_11_0_MK22FN512xxx12.tar.gz /home
RUN cd /home && tar -xvzf SDK_2_11_0_MK22FN512xxx12.tar.gz && rm SDK_2_11_0_MK22FN512xxx12.tar.gz 

# copy binary libraries to image
RUN mkdir /storelibs
COPY libc_nano.a libcr_newlib_nohost.a libm.a /storelibs/
COPY libarm_cortexM4lf_math.a /storelibs/
