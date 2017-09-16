# git2dot

This image allows you to run the git2dot tool on a local git repository
without installing graphviz.

I use it like this on my mac:

```bash
$ cd ~/myproject1
$ ls -1d .git
.git
$ docker run -it --rm -v $(pwd):/mnt/share git2dot.py --since 2017-08-01 --png -l "'%h|%s|%cn|%cr'" git.dot
$ open -a Preview git.dot.png
```

Using it on linux is exactly the same except for the viewer.

To see when the image was built:

```bash
$ docker inspect jlinoff/git2dot | grep '"Labels"' -A 4
```

To get more information about the git2dot tool see https://github.com/jlinoff/git2dot.
