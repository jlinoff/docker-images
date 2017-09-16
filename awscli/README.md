# aswcli

This directory contains the Dockerfile to create the
aws/cli image that can be used execute arbitrary AWS
commands from the CoreOS command line without having
AWS tools installed.

It is useful for CoreOS and other minimal systems where
you don't want to install unnecessary software.

I used to copy files to and from Amazon S3 archives.

You must have AWS credentials to use it.

Here is how you would use it to copy a file to S3.

```bash
$ docker run -it --rm -v $(pwd):/mnt/share -v ~/.boto:/etc/boto.cfg jlinoff/awscli aws s3 cp s3://foo/bar.dat .
$ ls -1 bar.dat
bar.dat
```

The `/mnt/share` directory is the directory where files are stored.

The `/etc/boto.cfg` file is the credentials file used to access AWS. It
looks like this:

```
[Credentials]
aws_access_key_id=<key>
aws_secret_access_key=<key>
```

Here is how you run the test:

```bash
$ make S3OBJECT=s3://my/path/to/object test
```
