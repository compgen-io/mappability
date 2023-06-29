#!/bin/bash


for size in 100 150; do
    #100bp/hg38F.hg38_chrY_100.map.txt.gz
    if [ -e "${size}bp/hg38F.hg38_chrY_${size}.map.txt.gz" ]; then
        rm -v "${size}bp/hg38F.hg38_chrY_${size}.map.txt.gz"
    fi
    cgsub -t 48:00:00 ./calc_mappability.py -bg {} \| bgzip \> {^.txt.gz}.bg.gz.tmp \&\& mv {^.txt.gz}.bg.gz.tmp {^.txt.gz}.bg.gz -- ${size}bp/hg38*.map.txt.gz
done
exit
