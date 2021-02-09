FROM python:3.7-slim

# install the notebook package
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook

RUN apt-get update && apt-get -yq dist-upgrade\
    && apt-get install -y git build-essential\
    && apt-get clean\
    && rm -rf /var/lib/apt/lists/*

LABEL maintainer="Simon Frost <sdwfrost@gmail.com>"
ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"

# create user with a home directory
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}
ENV NB_UID ${NB_UID}
ENV NB_GID ${NB_GID}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}
USER ${USER}

RUN mkdir -p ${HOME}/.local/bin

RUN cd /tmp\
    && git clone http://github.com/sdwfrost/giraf\
    && cd giraf/src\
    && make\
    && cp ./giraf ${HOME}/.local/bin

