bundle exec asciidoctor-revealjs -a slides -D reveal.js -a revealjsdir=. -a experimental=true -r asciidoctor-diagram src/$1.adoc -o index.html
