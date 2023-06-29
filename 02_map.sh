#!/bin/bash

for size in 100 150; do
for sex in F M; do
cgsub -p 4 -m 12G -t 24:00:00 --stdout logs/ --stderr logs/ \
--job-output ${size}bp/hg38${sex}.{@.fa}.map.txt.gz \
--job-output ${size}bp/hg38${sex}.{@.fa}.sam.gz  \
--joblog joblog.txt \
bwa mem -a -t 4 /N/p/spcg/resources/indexes/GRCh38.p5/genome${sex}.fa {} \| ./sam_filter.py ${size}bp/hg38${sex}.{@.fa}.map.txt.gz \| gzip \> ${size}bp/hg38${sex}.{@.fa}.sam.gz -- ${size}bp/fasta/*fa

done
done


