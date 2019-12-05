VMS=$(shell find -maxdepth 1 -type d | sed 's|./||' | grep "^[^_.]")

all: $(foreach _vm,$(VMS),_build/$(_vm)-rootfs.cpio.gz)
	@# this is called after the build
	chown vasek:vasek _build
	chmod 0755 _build

define VMBUILD
_build/$(1)-rootfs.cpio.gz: $(shell find $(1) -type f)
	./build.sh $(1)
.PHONY: $(1)
$(1): _build/$(1)-rootfs.cpio.gz
endef


$(foreach _vm, $(VMS), $(eval $(call VMBUILD,$(_vm))))

# this before anything gets done
$(shell if test "$$(id -u)" != "0"; then echo "Must be run as root"; exit 1; fi; mkdir -p _build; chown root:root _build; chmod 0700 _build;)

.PHONY: deploy
deploy:
	./deploy.sh
