rm -rf pdf
mkdir -p pdf
cp -R src/images pdf/
asciidoctor-pdf -d book -a experimental=true -a pdf-style=./custom-theme.yml -D ./pdf -r asciidoctor-diagram src/slide-deck.adoc
