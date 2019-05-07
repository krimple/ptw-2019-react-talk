### Pre-requsites

* Install RVM
* Use ruby current (v2.4.0 as of 6/16/2017)

### Setup procedure - lab content gen
```bash
cd lab-book
gem install bundler
gem install asciidoctor
gem install asciidoctor-pdf --pre
bundle install
```

### To generate lab book
```bash
cd lab-book
./generate-all.sh
```
