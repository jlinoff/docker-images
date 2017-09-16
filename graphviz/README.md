# graphviz

This image allows you to run the graphviz tools (like dot) without
installing graphviz.

I use it like this:

```bash
$ cd ~/myproject1
$ docker run -it --rm -v $(pwd):/mnt/share dot --help
```

To see when the image was built:

```bash
$ docker inspect jlinoff/graphviz | grep '"Labels"' -A 4
```
