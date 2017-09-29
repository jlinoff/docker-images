# Simple docker file that allows users to execute
# linux commands.
FROM ubuntu

RUN apt-get update -y
RUN apt-get install -y apt-utils
RUN apt-get install -y apt-transport-https
RUN apt-get install -y curl
RUN apt-get install -y wget
RUN apt-get install -y man
RUN apt-get install -y git
RUN apt-get install -y python python-pip python-dateutil python-virtualenv
RUN apt-get install -y sshpass

RUN mkdir /mnt/share
VOLUME /mnt/share
WORKDIR /mnt/share

LABEL com.github.jlinoff.docker-images.linuxcli.description="Execute linux commands."
LABEL com.github.jlinoff.docker-images.linuxcli.cmd="docker run -it --rm --init -v $(pwd):/opt/work jlinoff/linuxcli"

CMD ["/bin/bash"]
