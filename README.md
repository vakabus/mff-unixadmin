# ImmuVM

This is my obscure setup for unix administration class on MFF UK. It's a set of scripts used together to generate initial ramdisks for diskless VMs. That means, the VM's are kind of immutable. They can't be changed from within. However, to support manipulations with bigger data, the VMs can be configured to migrate themselves to disk shortly after boot.

## How to use this?

Building the VMs requires root permissions. :(

```sh
sudo make # when using parallel builds using -j30, set environment variable NO_CACHE=true
make deploy # to upload and start the VMs on the lecture's server
```

How to run the VMs locally?

```sh
sudo ./setup_local_test_network.sh # just once
supervisord -n # to run
```

## What does the build process look like?

`build.sh` script does the main work - it builds the VM that it gets as its first argument. The argument is nothing else than a directory name - directory that will be overlaid over standard rootfs. It also contains some special files like `packages.list`, which the `build.sh` script parses and uses for the actual image creation. So the actual build process looks basically like this:

* pacstrap with packages from `packages.list`
* copy the rootfs over the generated one by pacstrap
* do few funky optimizations
* compress it all into a CPIO archive

`Makefile` build script builds on top of the `build.sh` shell script. It just manages build for all the VMs, it calls `build.sh` script sequentially for all configured VMs.

As a result, images that could be used for boot end up all in `_build` directory.

## How is the runtime managed?

The actual runtime is governed by supervisord, simple service manager written in Python. I installed it using miniconda. `supervisord.conf` file contains all configuration it needs.

To actually start the runtime, `deploy.sh` script is used. It uploads all images to the host server and restarts the service manager. It can be called from the `Makefile`
