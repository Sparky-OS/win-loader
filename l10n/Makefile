LINGUAS=bg cs de en es fi fr he it ja nl pt ru sk sv

all: $(foreach lang, $(LINGUAS), templates/$(lang).nsh) po/messages.pot

templates/en.nsh: win32-loader.sh
	mkdir -p templates
	LANGUAGE=C ./win32-loader.sh > $@

templates/%.nsh: po/%.po win32-loader.sh po/messages.pot
	mkdir -p templates locale/$*/LC_MESSAGES
	msgmerge -U po/$*.po po/messages.pot
	msgfmt -c --statistics -o locale/$*/LC_MESSAGES/win32-loader.mo $<
	LANGUAGE=$* ./win32-loader.sh > $@

po/messages.pot: win32-loader.sh
	xgettext --from-code=utf-8 -ctranslate $^ -o $@

clean:
	rm -rf *~ templates locale
