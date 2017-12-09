#!/bin/bash
#
# Bootstrap the container environment to guarantee
# that the SSH service is running.
#

# ========================================================================
# Functions
# ========================================================================
# Help message.
function _help() {
    cat <<EOF
USAGE
    docker run [DOCKER_OPTIONS] DOCKER_IMAGE [OPTIONS]

DESCRIPTION
    Container bootstrap control.

    This container is meant to be used to create images
    that are configured by ansible or other orchestration
    and configuration tools and committed as new images
    that can be deployed for different configurations.

    The basic idea is to start this container and run ansible
    against it to configure it. When the configuration has
    completed, then container is then committed to a new
    image for re-use with the configuration. Here are the
    steps in a nutshell assuming that the image is named
    jlinoff/ssh-server-centos6.

        \$ # Step 1: start the container and run for an hour.
        \$ docker run -d -t --rm --init -p 2022:22 -v \$(pwd):/mnt/share \\
          -h base-container --name base-container \\
          jlinoff/ssh-server-centos6 \\
          sleep 3600

        \$ # Step 2: verify ssh access to the container.
        \$ ssh -p 2022 dev@localhost uptime

        \$ # Step 3: Run ansible.
        \$ ./run-my-ansible-playbook.sh dev localhost 2022

        \$ # Step 4. Create the updated image.
        \$ docker commit base-container my-image:latest

        \$ # Step 5. Start your new image.
        \$ docker run -i -t --rm --init -p 2022:22 -v \$(pwd):/mnt/share \\
          -h my-container --name my-container \\
          my-image

OPTIONS
    -h, --help      This help message.

    -k KEY, --key KEY
                    Authorized public key that is
                    to be added to the ~/.ssh/authorized_keys
                    to enable ssh password-less login.

                    The KEY parameter can be a string or
                    a file. If it is a file, it must be
                    in the /mnt/share volume.

    -n, --no-ssh    Do not run the ssh server.
                    This is only used for debugging.

    -v, --verbose   Increase the level of verbosity.
                    Accepts -vv to replace -v -v.

    -V, --version   Print the bootstrap version and exit.

EXAMPLES
    # Help
    \$ docker run -i -t --rm --init IMAGE --help

    # Version
    \$ docker run -i -t --rm --init IMAGE --version

COPYRIGHT
    Copyright (c) 2017 by Joe Linoff
    MIT Open Source License

EOF
}

# Get the command line options.
# Recall that BASH_ARGV is a stack
# so the arguments must be accessed
# in reverse order.
function _getopts() {
    local CMD=(1 0 '_')
    local LEN=${#BASH_ARGV[@]}
    for (( i=LEN-1; i>=0; i-- )) ; do
        OPT="${BASH_ARGV[$i]}"
        shift
        case "$OPT" in
            -h|--help)
                CMD+=("--help")
                break
                ;;
            -k|--key)
                (( i-- ))
                if (( i > -1 )) ; then
                    KEY="${BASH_ARGV[$i]}"
                    if [[ ! -z "$KEY" ]] ; then
                        if [[ "${CMD[2]}" == "_" ]] ; then
                            CMD[2]="$KEY"
                        else
                            CMD[2]+=",$KEY"
                        fi
                    fi
                fi
                ;;
            -n|--no-ssh)
                CMD[0]=0
                ;;
            -v|--verbose)
                CMD[1]=$(( ${CMD[1]} + 1 ))
                ;;
            -vv)
                # Special case of -v -v.
                CMD[1]=$(( ${CMD[1]} + 2 ))
                ;;
            -V|--version)
                CMD+=("--version")
                break
                ;;
            *)
                # We can use $* for the rest of the arguments.
                for (( ; i >= 0 ; i-- )) ; do
                    CMD+=("${BASH_ARGV[$i]}")
                done
                break
                ;;
        esac
    done
    echo "${CMD[@]}"
}

# Program main.
function main() {
    local CMD=($(_getopts))
    local RUN_SSH_SERVER=${CMD[0]}
    local VERBOSE=${CMD[1]}
    local KEYS=(${CMD[2]//,/ })

    CMD=(${CMD[@]:3})

    if (( VERBOSE > 1 )) ; then
        cat <<EOF

Parameters

   Args         : ${CMD[@]}
   Hostname     : $(hostname)
   Keys         : ${KEYS[@]}
   OS           : $(uname -rsv)
   RunSSHServer : $RUN_SSH_SERVER
   Script       : $0
   Time         : $(date)
   User         : $(whoami)
   Verbose      : $VERBOSE
   Version      : $VERSION

EOF
    fi

    (( VERBOSE > 1 )) && echo "INFO: Args = ${CMD[@]}." || true
    
    # Handle the pass throughs.
    if (( ${#CMD[@]} == 1 )) ; then
        case "${CMD[0]}" in
            --help)
                _help
                exit 0
                ;;
            --version)
                echo "version $VERSION"
                exit 0
                ;;
            *)
        esac
    fi

    # If key files were specified, add them to the
    # ~/.ssh/authorized_keys file.
    for KEY in ${KEYS[@]} ; do
        if [[ -f "$KEY" ]] ; then
            cat $KEY >> ~/.ssh/authorized_keys
        else
            echo $KEY >> ~/.ssh/authorized_keys
        fi
    done
    if [[ -f ~/.ssh/authorized_keys ]] ; then
        chmod 0600 ~/.ssh/authorized_keys
    fi

    # Start the ssh server unless the user specifically
    # told us not to.
    (( $RUN_SSH_SERVER > 0 )) && sudo service sshd restart || true

    # Process the command line arguments (if there were any).
    if (( ${#CMD[@]} )) ; then
        (( VERBOSE )) && echo "INFO: Running command: ${CMD[@]}." || true
        eval "${CMD[@]}"
    else
        # The user did not specify any arguments.
        # Run in batch mode forever.
        (( VERBOSE )) && echo "INFO: Running in batch mode." || true
        sleep infinity
    fi
    (( VERBOSE )) && echo "INFO: Done." || true
}

# ========================================================================
# Main
# ========================================================================
VERSION='1.0.0'
main


