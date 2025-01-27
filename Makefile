MARKDOWN := markdown
WWW := www
PDF := $(WWW)/pdf

pandoc = docker run --volume .:/data ghcr.io/ixth/pandoc/weasyprint

.PHONY: all clean watch
.SECONDEXPANSION:
.PRECIOUS: $(PDF)/%.pdf

all: \
	$(WWW)/cv.html \
	$(PDF)/en.pdf \
	$(PDF)/ru.pdf \
	$(PDF)/ru-senior.pdf \
	$(PDF)/ru-tech-lead.pdf \
	$(WWW)/Mikhail\ Menshikov\ -\ cv.pdf \
	$(WWW)/Михаил\ Меньшиков\ -\ cv.pdf

$(PDF)/%.pdf: $(MARKDOWN)/%.md
	$(pandoc) \
		--pdf-engine=weasyprint \
		--from gfm \
		--to html5 \
		--css styles/style.css \
		--quiet \
		--embed-resources \
		--standalone \
		--output $@ \
		$<

$(WWW)/%.html: $(MARKDOWN)/ru.md
	$(pandoc) \
		--from gfm \
		--to html5 \
		--css styles/style.css \
		--quiet \
		--embed-resources \
		--standalone \
		--output $@ \
		$<

$(WWW)/Михаил\ Меньшиков\ -\ cv.pdf: SRC_FILE = $(PDF)/ru.pdf
$(WWW)/Mikhail\ Menshikov\ -\ cv.pdf: SRC_FILE = $(PDF)/en.pdf
$(WWW)/%.pdf: $$(SRC_FILE)
	ln -fs "$$(realpath --no-symlinks --relative-to=$(WWW) $<)" "$@"

clean:
	rm $(PDF)/*.pdf $(WWW)/*.{pdf,html}

watch:
	(fswatch $(MARKDOWN)/en.md | xargs -n 1 make -B "$(WWW)/en.pdf" $(WWW)/cv.html) & \
	(fswatch $(MARKDOWN)/ru.md | xargs -n 1 make -B "$(WWW)/ru.pdf") & \
	(fswatch ./styles/* | xargs -n 1 make -B all)
