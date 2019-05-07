mkdir -p pdf/images
asciidoctor-pdf -a toc -a experimental=true -r asciidoctor-diagram -d book -D ./pdf -a pdf-style=./custom-theme.yml src/lab-book.adoc
open -g pdf/lab-book.pdf
# a2x --verbose -f pdf src/lab-styleguide.adoc
