# Unixadmin build setup

This is my obscure setup for unix administration class on MFF UK. It's a set of scripts used together to generate initial ramdisks for diskless VMs. It causes the VMs to have the property, that they can't be changed from within. For some tasks, thats too limiting, so when configured the VM can migrate itself to disk shortly after boot. The disk is not used as persistent storage. It's just a place how to make more disk space.

The whole setup is optimized to work on my machines. My credentials and public keys are hardcoded into some of the VMs. If you want to have fun with it too, expect that something will fail.

## Building of the VMs

Sadly, it requires root permissions. :( Pacstrap uses chroot and I haven't found a way how to bypass this limitation.

### Local build

You can build and deploy all the VMs on your machine by calling these commands:

```sh
sudo make # when using parallel builds using -j30, set environment variable NO_CACHE=true
make deploy # to upload and boot the VMs on the lecture's server
```

### Staged remote build

You can build just `buildvm`, machine configured to build other machines. Then deploy just that and build the rest from there in parallel on a big fat CPU. :) It has been all automated, just by calling `sudo make clean-and-full-staged-bootstrap`. This will clean all previous builds, build `buildvm`, deploy it, connect to it and use it to build and deploy the rest of the machines.

## Running the VMs locally

After running build, you can run the machines like this:

```sh
sudo ./setup_local_test_network.sh # just once
supervisord -n # to run
```

Sadly, you likely don't have enough RAM to run everything. :(

## What does the build process look like?

`build.sh` script does the main work - it builds the VM that it gets as its first argument. The argument is nothing else than a directory name - directory that will be overlaid over standard rootfs created by `pacstrap`. It also contains some special files like `packages.list` with a list of packages that will be installed in the VM. So the actual build process looks basically like this:

* pacstrap with packages from `packages.list`
* copy the appropriate directory over the pacstrap generated rootfs
* do few funky optimizations to lower disk usage
* compress it all into a CPIO archive

`Makefile` build script builds on top of the `build.sh` shell script. It just manages build for all the VMs, it calls `build.sh` script sequentially for all directories not starting with a underscore.

As a result, images that could be used for boot end up all in `_build` directory.

## How is the runtime of VMs managed?

The actual runtime is governed by supervisord, simple service manager written in Python. I installed it using miniconda on the lecture's server. `supervisord.conf` file contains all configuration it needs.

To actually start the runtime, `deploy.sh` script is used. It's usually called from the `Makefile`, but you can do it manually too. It uploads all images to the host server and restarts the service manager.
