# $ docker build -f Dockerfile -t jlinoff/git2dot:latest .
# $ docker run -it --rm --init -v $(pwd):/mnt/share jlinoff/git2dot git2dot.py -h
FROM ubuntu:latest

RUN apt-get update -y
RUN apt-get install -y apt-utils
RUN apt-get install -y apt-transport-https
RUN apt-get install -y man
RUN apt-get install -y graphviz
RUN apt-get install -y git
RUN apt-get install -y tzdata
RUN apt-get install -y python python-pip python-dateutil
RUN apt-get install -y fontconfig

# Accept the Microsoft End User License Agreement allowing the use of
# the MS True Type core fonts.
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula \
    select true | debconf-set-selections

# Install some fonts.
RUN apt-get install -y ttf-mscorefonts-installer
RUN apt-get install -y ttf-xfree86-nonfree
RUN apt-get install -y ttf-ubuntu-font-family
RUN apt-get install -y fonts-freefont-ttf
RUN apt-get install -y fonts-arkpandora
RUN apt-get install -y xfonts-100dpi
RUN apt-get install -y xfonts-75dpi
RUN apt-get install -y --reinstall ttf-mscorefonts-installer

# Update the font cache.
RUN fc-cache -f -s -v

# List the fonts.
RUN fc-list :style=regular | cat -n

# Install git2dot.
RUN cd /opt && \
    git clone https://github.com/jlinoff/git2dot.git && \
    cd git2dot/test && \
    ./test.sh
RUN cp /opt/git2dot/git2dot.py /usr/local/bin/

# Install a runner tool.
COPY runner.sh /usr/local/bin/runner.sh
RUN chmod 0755 /usr/local/bin/runner.sh

# Create the shared work area.
RUN mkdir /mnt/share
RUN cd /mnt/share
VOLUME /mnt/share

#LABEL com.github.jlinoff.docker-images.git2dot.build-date=2017-09-13T12:35:45-0700
LABEL com.github.jlinoff.docker-images.git2dot.description="Execute git2dot in the /mnt/share directory."
LABEL com.github.jlinoff.docker-images.git2dot.cmd="docker run -it --rm --init -v $(pwd):/mnt/share jlinoff/git2dot git2dot --png git.dot"

ENTRYPOINT ["/usr/local/bin/runner.sh"]

