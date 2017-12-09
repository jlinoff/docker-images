# Create a server that can handle ansible.
FROM centos:6.9

ARG ROOT_PASS=root
ARG USER_NAME=dev
ARG USER_PASS=dev

USER root

RUN yum clean all
RUN yum update -y
RUN yum install -y yum-plugin-ovl
RUN yum install -y yum-utils
RUN yum install -y epel-release
RUN yum install -y sudo
RUN yum install -y curl
RUN yum install -y openssl
RUN yum install -y openssh openssh-server openssh-clients

RUN ssh-keygen -q -N '' -t rsa     -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N '' -t dsa     -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N '' -t ecdsa   -f /etc/ssh/ssh_host_ecdsa_key
RUN ssh-keygen -q -N '' -t rsa     -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

RUN echo "root:${ROOT_PASSWORD}" | chpasswd
RUN mkdir /mnt/share

# Install the local bootstrap.
COPY /bootstrap.sh /usr/local/libexec
RUN chmod 0755 /usr/local/libexec/bootstrap.sh

# Create the sudo USER.
RUN useradd -G wheel -m ${USER_NAME}
RUN echo "${USER_NAME}:${USER_PASS}" | chpasswd
RUN echo '%wheel	ALL=(ALL)	NOPASSWD: ALL' >>/etc/sudoers

# Setup password less login.
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}
RUN pwd
RUN mkdir -p -m 0700 /home/${USER_NAME}/.ssh

WORKDIR /home/${USER_NAME}/.ssh
RUN pwd
RUN ssh-keygen -q -N '' -t rsa -f id_rsa
RUN cat id_rsa.pub >> authorized_keys
RUN chmod 0600 authorized_keys
WORKDIR /home/${USER_NAME}

# Setup the share volume.
VOLUME /mnt/share

# Export port 22.
EXPOSE 22

# Bootstrap to make sure that the sshd
# service is running.
ENTRYPOINT ["/usr/local/libexec/bootstrap.sh"]
