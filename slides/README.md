## Instructions for slide/pdf generation

### Pre-requsites

* Install RVM
* Use ruby current (v2.4.0 as of 6/16/2017)
* Install the following Python packages:  cairo (with `brew install py3cairo` )
### Setup procedure - slide and lab content gen
```bash
cd slides
gem install bundler
gem install asciidoctor
gem install asciidoctor-pdf --pre
bundle install

cd labs
gem install bundler
gem install asciidoctor
gem install asciidoctor-pdf --pre
bundle install
```

### To generate printed slide book

```bash
cd slides
./generate-slide-book.sh
```

### To generate reveal.js slides

```bash
cd slides
./generate-slide-deck.sh
```

### To generate the lab book
```bash
cd lab-book
./generate-all.sh
```

### To adjust the Chariot theme for slides

```bash
cd slides/reveal.js
npm install
./node_modules/.bin/grunt css-themes
```

