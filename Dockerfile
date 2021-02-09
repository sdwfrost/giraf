FROM ubuntu:20.04

RUN apt-get update && apt-get -yq dist-upgrade\
    && apt-get install -y gcc make\
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
ENV PATH "${HOME}/.local/bin:$PATH"

RUN cd ${HOME} && mkdir -p giraf/src && mkdir -p giraf/bin
COPY src giraf/src
COPY bin giraf/bin
RUN cd giraf/src\
    && make\
    && cp ./giraf ${HOME}/.local/bin\
    && cd ..\
    && cp bin/* ${HOME}/.local/bin\
    && cd ${HOME}\
    && rm -rf giraf

