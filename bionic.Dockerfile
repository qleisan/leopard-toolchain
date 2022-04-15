FROM ubuntu:bionic
LABEL Description="Image for buiding arm project with mcuxpresso"
WORKDIR  /usr/src/mcuxpresso

ENV DEBIAN_FRONTEND noninteractive
#ENV IDE_VERSION 11.0.0_2516
ENV IDE_VERSION 11.5.0_7232

# https://stackoverflow.com/questions/66353515/mcuxpresso-eclipse-project-with-c-automatic-headless-build
#COPY mcuxpresso/mcuxpressoide-${IDE_VERSION}.x86_64.deb.bin /usr/src/mcuxpresso
COPY mcuxpressoide-${IDE_VERSION}.x86_64.deb.bin /usr/src/mcuxpresso

# Install any needed packages specified in requirements.txt /usr/src/mcuxpresso
RUN apt update && \
    apt upgrade -y && \
    apt install -y \
    # Development files
    whiptail \
    build-essential \
    bzip2 \
    libswt-gtk-3-jni \
    libswt-gtk-3-java \
    wget && \
    apt clean

# Install mcuxpresso
RUN chmod a+x mcuxpressoide-${IDE_VERSION}.x86_64.deb.bin &&\
  # Extract the installer to a deb package
  ./mcuxpressoide-${IDE_VERSION}.x86_64.deb.bin --noexec --target mcu &&\
  cd mcu &&\
  dpkg --add-architecture i386 && apt-get update &&\
  apt-get install -y libusb-1.0-0-dev dfu-util libwebkitgtk-1.0-0 libncurses5:i386 udev &&\
  dpkg -i --force-depends JLink_Linux_x86_64.deb &&\
  # manually install mcuxpressoide - post install script fails
  dpkg --unpack mcuxpressoide-${IDE_VERSION}.x86_64.deb &&\
  rm /var/lib/dpkg/info/mcuxpressoide.postinst -f &&\
  dpkg --configure mcuxpressoide &&\
  apt-get install -yf &&\
  # manually run the postinstall script
  mkdir -p /usr/share/NXPLPCXpresso &&\
  chmod a+w /usr/share/NXPLPCXpresso &&\
  ln -s /usr/local/mcuxpressoide-${IDE_VERSION} /usr/local/mcuxpressoide

ENV TOOLCHAIN_PATH /usr/local/mcuxpressoide/ide/tools/bin
ENV PATH $TOOLCHAIN_PATH:$PATH    

RUN rm mcuxpressoide-${IDE_VERSION}.x86_64.deb.bin
RUN rm -rf mcu

# qleisan
RUN apt install unzip
COPY SDK_2.3.0_MK22FN512xxx12.zip /home
RUN cd /home && unzip SDK_2.3.0_MK22FN512xxx12.zip -d /home/SDK

