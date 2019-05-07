pandoc -f markdown -V fontsize=12pt --smart -V documentclass=report  -V geometry:margin=1in --normalize --toc -o slideshow.pdf components.md 
open slideshow.pdf 
