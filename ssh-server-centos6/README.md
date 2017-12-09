# ssh-server

This directory contains the Dockerfile to create the ssh-server image
that runs containers that execute an ssh-server on centos6 that can be
used by configuration tools like Ansible that are later committed as
deployable images with different configurations.

The idea is to run "make build" to create the base image that will
later be configured.

### Example 1. The whole flow.

Here is an example that will configure an image using an ansible
playbook which is then saved for deployment.

```bash
$ # ================================================================
$ # 1. Make the container
$ # ================================================================
$ make build
            
$ # ================================================================
$ # 2. Start the container for an hour to keep it alive long
$ #    enough to configure and commit.
$ #    To enable ssh password-less login, copy over the
$ #    public key you want to add to ~/.ssh/authorized_keys.
$ #    and pass it as the key parameter before the sleep
$ #    command.
$ # ================================================================
$ cp ~/.ssh/id_rsa.pub .
$ docker run -i -t --rm --init -p 2022:22 \
     -v $(pwd)/mnt/share \
     -h base-container --name base-container \
      jlinoff/ssh-server-centos6 \
      --key /mnt/share/id_rsa.pub sleep 3600

$ # ================================================================
$ # 3. Verify ssh access to the container.
$ # ================================================================
$ ssh -p 2022 dev@localhost

$ # ================================================================
$ # 4. Configure using ansible run by a wrapper script.
$ # ================================================================
$ ./my-ansible-playbook-runner.sh dev@localhost 2022

$ # ================================================================
$ # 5. Save the configured image for re-use.
$ # ================================================================
$ docker commit base-container my-new-image:1.2.3
$ docker tag my-new-image:1.2.3 my-new-image:latest

$ # ================================================================
$ # 6. Start the new image for testing.
$ #    By default it runs forever as an ssh-server (bash mode).
$ # ================================================================
$ docker run -i -t --rm --init -p 2023:22 \
     -v $(pwd)/mnt/share \
     -h my-new-container --name my-new-container \
      my-new-image

$ # ================================================================
$ # 7. Login and do stuff.
$ #    You can use ssh or docker exec.
$ # ================================================================
$ ssh -p 2023 dev@localhost

$ # ================================================================
$ # 8. All done, save the image or upload it using push.
$ # ================================================================
$ docker save -o my-new-image.tar my-new-container
```

### Example 2. Help.

The bootstrap system has a couple of interesting features.
You can find out about them by specifying the `--help`
option when you a container. Here is an example. Note that you
do not need to worry about ports or volumes.

```bash
$ docker run -i -t --rm --init jlinoff/ssh-server-centos6 --help
```

### Example 3. Verbosity.

You can get a little bit of context information by specifying
verbose options. The verbose options must be specified before
any commands. Here is an example.

```bash
$ docker run -i -t --rm --init jlinoff/ssh-server-centos6 -v -v uname -a
```

