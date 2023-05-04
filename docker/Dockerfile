FROM nvidia/cuda:12.0.1-cudnn8-devel-ubuntu18.04
############################## SYSTEM PARAMETERS ##############################
# * Arguments
ARG USER=initial
ARG GROUP=initial
ARG UID=1000
ARG GID="${UID}"
ARG SHELL=/bin/bash
ARG HARDWARE=x86_64
ARG ENTRYPOINT_FILE=entrypint.sh

# * Env vars for the nvidia-container-runtime.
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all
# ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute

# * Setup users and groups
RUN groupadd --gid "${GID}" "${GROUP}" \
    && useradd --gid "${GID}" --uid "${UID}" -ms "${SHELL}" "${USER}" \
    && mkdir -p /etc/sudoers.d \
    && echo "${USER}:x:${UID}:${UID}:${USER},,,:/home/${USER}:${shell}" >> /etc/passwd \
    && echo "${USER}:x:${UID}:" >> /etc/group \
    && echo "${USER} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${USER}" \
    && chmod 0440 "/etc/sudoers.d/${USER}"

# * Replace apt urls
# ? Change to tku
RUN sed -i 's@archive.ubuntu.com@ftp.tku.edu.tw@g' /etc/apt/sources.list
# ? Change to Taiwan
# RUN sed -i 's@archive.ubuntu.com@tw.archive.ubuntu.com@g' /etc/apt/sources.list

# * Time zone & Locale
ENV TZ=Asia/Taipei

ENV LANG=en_US.UTF-8
ENV LANGAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN ln -snf /usr/share/zoneinfo/"${TZ}" /etc/localtime && echo "${TZ}" > \
        /etc/timezone


############################### INSTALL #######################################
# * Install packages
COPY ./sdkmanager_1.9.2-10889_amd64.deb \
    /sdkmanager_1.9.2-10889_amd64.deb

RUN apt update \
    && apt install -y --no-install-recommends \
        sudo \
        git \
        htop \
        wget \
        curl \
        psmisc \
        locales \
        libnss3 \
        libgbm1 \
        libxshmfence1 \
        libdrm2 \
        locales \
        dbus \
        libx11-xcb1 \
        libxcb-*-dev \
        libgconf-2-4 \
        libcanberra-gtk-module \
        libcanberra-gtk3-module \
        qemu-user-static \
        netcat \
        usbutils \
        openssh-server \
        libgtk-3-0 \
        libx11-xcb-dev \
        libnss3 \
        nodejs \
        npm \
        # * Shell
        tmux \
        terminator \
        # * base tools
        /sdkmanager_1.9.2-10889_amd64.deb \
        # * Work tools
        && \
    apt clean  && \
    rm -rf /var/lib/apt/lists/*

RUN if [ ! -f /etc/locale.gen  ]; then touch /etc/locale.gen; fi && \
    sed -i -e "s/# $LANG.*/$LANG UTF-8/" /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=$LANG

# gnome-terminal libcanberra-gtk-module libcanberra-gtk3-module \
# dbus-x11 libglvnd0 libgl1 libglx0 libegl1 libxext6 libx11-6 \

############################### OTHER #######################################
# * Copy entrypoint
# ? Requires docker version >= 17.09
COPY --chmod=0775 ./${ENTRYPOINT_FILE} /entrypoint.sh
# ? docker version < 17.09
# COPY ./${ENTRYPOINT_FILE} /entrypoint.sh
# RUN sudo chmod 0775 /entrypoint.sh

# * Switch user to ${USER}
USER ${USER}

ENTRYPOINT [ "bash" ]
#ENTRYPOINT [ "/entrypoint.sh" ]
