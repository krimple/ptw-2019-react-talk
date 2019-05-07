./generate-book-chapter.sh $1
./generate-print-slides.sh $1
pdfjam --suffix 2up --nup '1x2' --frame 'true' --noautoscale 'false' \
    --delta '0cm 0.2cm' --scale '0.77' --offset '-0.8cm 0cm' \
    --pagecommand '{\thispagestyle{empty}}' \
    --outfile ./pdf/print/$1-2up.pdf \
    --preamble '\footskip 3.1cm' -- ./pdf/$1.pdf

open ./pdf/print/$1-2up.pdf
