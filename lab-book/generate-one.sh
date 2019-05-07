mkdir -p pdf/images
asciidoctor-pdf -a toc -a experimental=true -r asciidoctor-diagram -d book \
   -D ./pdf -a pdf-style=./custom-theme.yml src/$1.adoc
