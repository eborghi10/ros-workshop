FROM osrf/ros:melodic-desktop-bionic

LABEL maintainer="eborghiorue@frba.utn.edu.ar"

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common
RUN add-apt-repository universe
RUN apt-get update && apt-get install -y \
    apache2 \
    curl \
    git \
    python3 \
    python3-pip \
    libgl1-mesa-dev \
    x11-apps \
    xorg \
    xvfb
RUN pip3 install --upgrade pip

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-melodic-common-tutorials \
    ros-melodic-ros-tutorials \
    && rm -rf /var/lib/apt/lists/*

# install jupyter and configure
RUN pip3 install \
    bqplot \
    ipykernel \
    ipywidgets \
    jupyterlab \
    matplotlib \
    notebook \
    pyyaml

ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}

USER ${NB_USER}
WORKDIR ${HOME}

ENV DISPLAY=:99.0
ENV QT_QPA_PLATFORM=offscreen
RUN /usr/bin/Xorg -depth 16&
# modify the CMD and start a background server first
CMD ["jupyter", "lab", "--no-browser", "--ip", "0.0.0.0"]
