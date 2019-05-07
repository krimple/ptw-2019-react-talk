rd /s /q reveal.js\images
mkdir reveal.js\images
xcopy src\images\*.* reveal.js\images /s/e
generate-slides.cmd slide-deck
