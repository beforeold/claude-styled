.PHONY: build install uninstall verify icon clean

build:
	./scripts/build.sh

install:
	./scripts/install.sh

uninstall:
	./scripts/uninstall.sh

verify:
	./scripts/verify.sh

icon:
	./scripts/make-icon.sh

clean:
	/bin/rm -rf "$(CURDIR)/dist"
