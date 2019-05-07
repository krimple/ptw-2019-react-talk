echo "starting `date`"
rm -rf pdf
mkdir -p pdf
cp -R src/images pdf/
asciidoctor-pdf -a toc -a experimental=true -r asciidoctor-diagram -d book \
   -D ./pdf -a pdf-style=./custom-theme.yml src/lab-book.adoc
echo "done `date`"
