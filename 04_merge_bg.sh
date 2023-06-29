#!/bin/bash

for size in 100 150; do
    FILESF=""
    FILESM=""

    for chrom in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X M; do
        FILESF="$FILESF ${size}bp/hg38F.hg38_chr${chrom}_${size}.map.bg.gz"
    done

    for chrom in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y M; do
        FILESM="$FILESM ${size}bp/hg38M.hg38_chr${chrom}_${size}.map.bg.gz"
    done

    echo $FILESF | xargs gunzip -c | bgzip > ${size}bp/hg38F.merged.map.${size}.bg.gz
    echo $FILESM | xargs gunzip -c | bgzip > ${size}bp/hg38M.merged.map.${size}.bg.gz

    tabix -f -p bed ${size}bp/hg38F.merged.map.${size}.bg.gz
    tabix -f -p bed ${size}bp/hg38M.merged.map.${size}.bg.gz
done
