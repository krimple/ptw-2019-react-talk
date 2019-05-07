rm -rf pdf
mkdir -p pdf
cp -R src/images pdf/
asciidoctor-pdf -d book -r asciidoctor-diagram -a experimental=true -a pdf-style=./custom-theme.yml -D ./pdf src/01-introduction.adoc
asciidoctor-pdf -d book -r asciidoctor-diagram -a experimental=true -a pdf-style=./custom-theme.yml -D ./pdf src/02-es2015-16.adoc
asciidoctor-pdf -d book -r asciidoctor-diagram -a experimental=true -a pdf-style=./custom-theme.yml -D ./pdf src/03-react-ecosystem.adoc
asciidoctor-pdf -d book -r asciidoctor-diagram -a experimental=true -a pdf-style=./custom-theme.yml -D ./pdf src/04-components-and-views.adoc
asciidoctor-pdf -d book -r asciidoctor-diagram -a experimental=true -a pdf-style=./custom-theme.yml -D ./pdf src/05-components-state-and-events.adoc
asciidoctor-pdf -d book -r asciidoctor-diagram -a experimental=true -a pdf-style=./custom-theme.yml -D ./pdf src/06-advanced-components.adoc
asciidoctor-pdf -d book -r asciidoctor-diagram -a experimental=true -a pdf-style=./custom-theme.yml -D ./pdf src/07-router.adoc
asciidoctor-pdf -d book -r asciidoctor-diagram -a experimental=true -a pdf-style=./custom-theme.yml -D ./pdf src/08-forms.adoc
asciidoctor-pdf -d book -r asciidoctor-diagram -a experimental=true -a pdf-style=./custom-theme.yml -D ./pdf src/09-redux.adoc
asciidoctor-pdf -d book -r asciidoctor-diagram -a experimental=true -a pdf-style=./custom-theme.yml -D ./pdf src/10-async-redux.adoc
asciidoctor-pdf -d book -r asciidoctor-diagram -a experimental=true -a pdf-style=./custom-theme.yml -D ./pdf src/11-ajax.adoc
asciidoctor-pdf -d book -r asciidoctor-diagram -a experimental=true -a pdf-style=./custom-theme.yml -D ./pdf src/slide-deck.adoc

