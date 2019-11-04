# ImmuVM

This is my setup for unix administration class on MFF UK. It's a set of scripts used together to generate initial ramdisks for diskless VMs. That means, the VM's are kind of immutable. They can't be changed from within.

## How to use this?

Building the VMs requires root permissions. :(

```sh
sudo ./build_all.sh
# calls ./build.sh VM_SPEC_DIR
./deploy.sh  # to upload and start the VMs on the lecture's server
```

How to run the VMs locally?

```sh
sudo ./setup_local_test_network.sh # just once
supervisord -n # to run
```
