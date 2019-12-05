VMS=$(shell find -maxdepth 1 -type d | sed 's|./||' | grep "^[^_.]")

all: $(foreach _vm,$(VMS),_build/$(_vm)-rootfs.cpio.gz)

define VMBUILD
_build/$(1)-rootfs.cpio.gz: $(shell find $(1) -type f)
	@if test "$$$$(id -u)" != "0"; then \
		echo "Must be run as root"; \
		exit 1; \
	fi
	@mkdir -p _build
	@chown root:root _build
	@chmod 0700 _build

	./build.sh $(1)

	@#chown vasek:vasek _build
	@chmod 0755 _build

.PHONY: $(1)
$(1): _build/$(1)-rootfs.cpio.gz
endef


$(foreach _vm, $(VMS), $(eval $(call VMBUILD,$(_vm))))

.PHONY: deploy
deploy:
	./deploy.sh

clean-and-full-staged-bootstrap:
	rm -rf _build
	@$(MAKE) --no-print-directory buildvm
	sudo -u vasek ./deploy.sh
	sleep 20
	sudo -u vasek ssh -J unixadmin 10.0.0.238 "make_vms.sh"

clean-and-full-bootstrap: all
	sudo -u vasek ./deploy.sh
