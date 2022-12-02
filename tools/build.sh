docker run --volume .:/data ghcr.io/ixth/pandoc/weasyprint \
    --from gfm \
    --to html5 \
    --pdf-engine=weasyprint \
    --css styles/style.css \
    --output "$2" \
    --embed-resources \
    --standalone \
    "$1"
