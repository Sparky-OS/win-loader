LINGUAS=en

all: $(foreach lang, $(LINGUAS), templates/$(lang).nsh)

templates/en.nsh: generate_template.sh
	mkdir -p templates
	LANGUAGE=C ./generate_template.sh > $@

templates/%.nsh: po/%.po generate_template.sh
	mkdir -p templates locale/$*/LC_MESSAGES
	msgfmt -c --statistics -o locale/$*/LC_MESSAGES/win32-loader.mo $<
	LANGUAGE=$* ./generate_template.sh > $@

clean:
	rm -rf *~ templates locale
