FROM snakemake/snakemake:v5.32.1
MAINTAINER Simon Frost <sdwfrost@gmail.com>
ADD . /tmp/giraf
RUN mkdir -p /opt/bin
ENV PATH /opt/bin:${PATH}

RUN pip install azure-storage-blob kubernetes

RUN apt-get update && apt-get -yq dist-upgrade\
    && apt-get install -y wget g++ make libhmsbeagle1v5 mrbayes\
    && apt-get clean\
    && rm -rf /var/lib/apt/lists/*

RUN cd /tmp/giraf/src\
    && make\
    && cp ./giraf /opt/bin\
    && cd ..\
    && cp bin/* /opt/bin\
    && cd /tmp\
    && rm -rf giraf

