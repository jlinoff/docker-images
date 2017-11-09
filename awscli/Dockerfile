# Execute an Amazon AWS CLI command using your credentials.
# This is useful for CoreOS systems that only act as docker engines.
# I chose the alpine distro because it is really small.
#
# Build:
#    Get the RFC-3339 formatted date: date +%Y-%m-%dT%T%z
#    $ docker build -f Dockerfile --label=org.label-schema.build-date=$(date +%Y-%m-%dT%T%z) -t jlinoff/awscli:latest .
#
# Run:
#    $ docker run -it --rm -v $(pwd):/mnt/share -v ~/.boto:/etc/boto.cfg jlinoff/awscli aws s3 ls s3://path/to/stuff.
#    $ #                    ^                    ^
#    $ #                    |                    +------ Where to find the boto credentials file.
#    $ #                    +--------------------------- Where common data is written.
FROM alpine

#LABEL com.github.jlinoff.docker-images.awscli.build-date=2017-09-13T12:35:45-0700
LABEL com.github.jlinoff.docker-images.awscli.description="Execute an Amazon AWS CLI command using your credentials."
LABEL com.github.jlinoff.docker-images.awscli.docker.cmd="docker run -it --rm -v ~:/mnt/share -v ~/.boto:/etc/boto.cfg jlinoff/awscli aws s3 cp s3://path/to/stuff/foo ."

ENV PATH="${PATH}:/root/.local/bin"

RUN apk update
RUN apk add python2 py2-pip less groff
RUN pip install --upgrade pip
RUN pip install awscli --upgrade --user

RUN mkdir -p /mnt/share
VOLUME /mnt/share

COPY runner.sh /root/runner.sh
RUN chmod a+x /root/runner.sh

ENTRYPOINT ["/root/runner.sh"]
