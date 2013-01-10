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

.PHONY : version 

libkoca.sh: make.sh libs/*.sh
	./make.sh $@

clean: bclean dclean

version:
	@bash $(FN) version

install: $(PREFIX)/libkoca.sh

$(PREFIX)/libkoca.sh: libkoca.sh
	mkdir -p $(PREFIX)
	rm -f $(PREFIX)/commun.sh
	install -m0644 $< $(PREFIX)
	rm -f $(PREFIX)/commun.sh
	echo 'echo "Unused" >&2' > $(PREFIX)/commun.sh


-include commun.mk
