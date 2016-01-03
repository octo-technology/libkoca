#$Id: Makefile 1161 2013-01-03 10:28:56Z gab $
PROJECT=libkoca.sh
CATEGORY=autre
DISTNAME=shlibkoca
VERSIONFROM=make version
DESCRIPTION='Useful shell functions'
MAKEFLAGS += --no-print-directory

PREFIX=/usr/local/include
FN=libkoca.sh
FNMODE=0644
WWW_DIR:=/var/www/files

.PHONY : version libkoca.sh

libkoca.sh: make.sh libs/*.sh
	./make.sh $@

clean: bclean dclean

version:
	@bash $(FN) version
ifneq "" "$(shell getent passwd www-data)"
install: $(PREFIX)/libkoca.sh $(WWW_DIR)/libkoca.sh
else
install: $(PREFIX)/libkoca.sh
endif

$(PREFIX)/libkoca.sh: libkoca.sh
	install -D -m0644 $< $@
	rm -f $(PREFIX)/commun.sh
	echo 'echo "Unused" >&2' > $(PREFIX)/commun.sh

$(WWW_DIR)/libkoca.sh: libkoca.sh
	install -o www-data -m0644 $< $@

-include commun.mk
