rm -rf pdf
mkdir -p pdf
cp -R src/images pdf/
asciidoctor-pdf -d book -r asciidoctor-diagram -a experimental=true -a pdf-style=./custom-theme.yml -D ./pdf src/$1

