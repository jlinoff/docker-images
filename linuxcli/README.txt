This dockerfile provides a simple container that can execute linux
commands like xz and curl.

It exists for colleagues that do not have linux hosts, need access to
linux commands and do not want to install the packages on their macs
or windows hosts.

It uses ubuntu linux as the base system.

You run it like this:

   $ docker run -it --rm --init -v $(pwd):/mnt/share jlinoff/linuxcli pwd
   $ docker run -it --rm --init -v $(pwd):/mnt/share jlinoff/linuxcli ls -l
   $ docker run -it --rm --init -v $(pwd):/mnt/share jlinoff/linuxcli xz big_file
