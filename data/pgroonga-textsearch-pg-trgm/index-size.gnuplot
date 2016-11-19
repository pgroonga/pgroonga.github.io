# set terminal pdfcairo enhanced color transparent rounded
set terminal svg

set key outside center top horizontal reverse Left samplen 2
unset border
set xtics scale 0
set ytics scale 0
set grid ytics linewidth 1 linetype -1

set style line 1 lt 1 lc rgbcolor "#3465a4" lw 2.5 pt 7 ps 1
set style line 2 lt 1 lc rgbcolor "#edd400" lw 2.5 pt 7 ps 1
set style line 3 lt 1 lc rgbcolor "#888a85" lw 2.5 pt 5 ps 1
set style line 4 lt 1 lc rgbcolor "#f57900" lw 2.5 pt 5 ps 1
set style line 5 lt 1 lc rgbcolor "#ad7fa8" lw 2.5 pt 9 ps 1
set style line 6 lt 1 lc rgbcolor "#4e9a06" lw 2.5 pt 9 ps 1
set style line 7 lt 1 lc rgbcolor "#ef2929" lw 2.5 pt 1 ps 1
set style line 8 lt 1 lc rgbcolor "#5c3566" lw 2.5 pt 1 ps 1
set style line 9 lt 1 lc rgbcolor "#c17d11" lw 2.5 pt 3 ps 1
set style line 10 lt 1 lc rgbcolor "#dce775" lw 2.5 pt 3 ps 1

set title "Index size"

set xlabel "Module"
set ylabel "Size (GB)\n(Shorter is better)"
set noxtic

set yrange[0:]

set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.9

set label 1 \
          "Data: English Wikipedia" \
          at 0.4,34 left
set label 2 \
          "Size: About 33GiB" \
          at 0.4,31.5 left
set label 3 \
          "Max text size: 1MiB" \
          at 0.4,29 left
set output "index-size.svg"
plot "index-size.tsv" using 1 \
       title columnheader \
       linestyle 5, \
     "index-size.tsv" using 2 \
       title columnheader \
       linestyle 1, \
     "index-size.tsv" using 3 \
       title columnheader \
       linestyle 6
