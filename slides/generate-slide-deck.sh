rm -R ./reveal.js/images
mkdir ./reveal.js/images
cp -R ./src/images/* reveal.js/images
./generate-slides.sh slide-deck
