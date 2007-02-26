LINGUAS=bg cs de en fi fr he it ja nl pt sk sv

all: $(foreach lang, $(LINGUAS), templates/$(lang).nsh) po/messages.pot

templates/en.nsh: generate_template.sh
	mkdir -p templates
	LANGUAGE=C ./generate_template.sh > $@

templates/%.nsh: po/%.po generate_template.sh po/messages.pot
	mkdir -p templates locale/$*/LC_MESSAGES
	msgmerge -U po/$*.po po/messages.pot
	msgfmt -c --statistics -o locale/$*/LC_MESSAGES/win32-loader.mo $<
	LANGUAGE=$* ./generate_template.sh > $@

po/messages.pot: generate_template.sh
	xgettext --from-code=utf-8 -ctranslate $^ -o $@

clean:
	rm -rf *~ templates locale
