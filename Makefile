# Makefile for alert

name = alert
specfile = $(name).spec

version := $(shell awk 'BEGIN { FS=":" } /^Version:/ { print $$2}' $(specfile) | sed -e 's/ //g' -e 's/\$$//')

prefix = /usr
datadir = $(prefix)/share
mandir = $(datadir)/man
etcdir = /etc


# ronn is a tool to generate man-pages directly from MarkDown files
ronn := $(shell if type -p ronn >/dev/null; then echo ronn; fi)

distversion = $(version)
rpmrelease =


CC = gcc
CFLAGS = -Wall -O2
LDFLAGS = -lcurl

TARGET = $(name)
SRC = $(name).c
BIN_DIR = usr/bin

all: build
	@echo "Nothing to build. Use \`make help' for more information."

build: $(TARGET)

$(TARGET): $(SRC)
	@echo -e "\033[1m== Compiling the sources ==\033[0;0m"
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
	strip $(name)

help:
	@echo -e "alert make targets:\n\
\n\
  install         - Install alert to BINDIR (may replace files)\n\
  dist            - Create tar file\n\
  rpm             - Create RPM package\n\
\n\
"

man: $(name).8

%.8: %.8.md
	@echo -e "\033[1m== Generating man page ==\033[0;0m"
	LANG=en_US.UTF-8 $(ronn) --roff $<
	echo "Man page was successfully created."

clean:
	@echo -e "\033[1m== Cleanup temporary files ==\033[0;0m"
	rm -f $(TARGET) *.o
	-rm -f $(name).8
	-rm $(name)-$(distversion).tar.gz

.PHONY: all clean


dist: clean $(name)-$(distversion).tar.gz

$(name)-$(distversion).tar.gz: $(name).spec
	@echo -e "\033[1m== Building archive $(name)-$(distversion) ==\033[0;0m"
	tar -czf $(name)-$(distversion).tar.gz --transform='s,^,$(name)-$(version)/,S' \
	Makefile $(name).spec COPYING $(name).c $(name).8.md
	
rpm: dist $(name).spec
	@echo -e "\033[1m== Building RPM package $(name)-$(distversion)==\033[0;0m"
	rpmbuild -ta --clean \
		--define "_rpmfilename %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm" \
		--define "debug_package %{nil}" \
		--define "_rpmdir %(pwd)" $(name)-$(distversion).tar.gz

install: man $(TARGET)
	@echo -e "\033[1m== Installing $(TARGETS)  ==\033[0;0m"
	install -Dp -m0755 $(name)   $(DESTDIR)/$(BIN_DIR)/$(name)
	install -Dp -m0644 $(name).8 $(DESTDIR)$(mandir)/man8/$(name).8
