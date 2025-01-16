.PHONY: all clean watch

all: www/cv.html "www/Mikhail\ Menshikov\ -\ cv.pdf" "www/Михаил\ Меньшиков\ -\ cv.pdf"

"www/Mikhail\ Menshikov\ -\ cv.pdf": MARKDOWN_FILE = markdown/en.md
"www/Михаил\ Меньшиков\ -\ cv.pdf": MARKDOWN_FILE = markdown/ru.md
"www/%.pdf":
	docker run --volume .:/data ghcr.io/ixth/pandoc/weasyprint \
		--from gfm \
		--to html5 \
		--pdf-engine=weasyprint \
		--css styles/style.css \
		--output $@ \
		--embed-resources \
		--standalone \
		$(MARKDOWN_FILE)

www/cv.html: MARKDOWN_FILE = markdown/ru.md
www/%.html:
	docker run --volume .:/data ghcr.io/ixth/pandoc/weasyprint \
		--from gfm \
		--to html5 \
		--css styles/style.css \
		--output $@ \
		--embed-resources \
		--standalone \
		$(MARKDOWN_FILE)

clean:
	rm www/*.pdf www/*.html

watch:
	(fswatch ./markdown/en.md | xargs -n 1 make -B "www/Mikhail Menshikov - cv.pdf" www/cv.html) & \
	(fswatch ./markdown/ru.md | xargs -n 1 make -B "www/Михаил Меньшиков - cv.pdf") & \
	(fswatch ./styles/* | xargs -n 1 make -B all)
