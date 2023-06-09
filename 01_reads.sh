#!/bin/bash

mkdir -p 100bp/fasta 150bp/fasta

~/ngsutilsj fasta-split --template 'fasta/hg38_' /N/p/spcg/resources/indexes/GRCh38.p5/genome.fa

cgsub -t 8:00:00 -m 4G --stdout logs/ --stderr logs/ JAVA_OPTS="-Xmx3G" ~/ngsutilsj fasta-genreads --fasta -l 100 {} \> 100bp/fasta/{@.fa}_100.fa -- fasta/hg38*.fa
cgsub -t 8:00:00 -m 4G --stdout logs/ --stderr logs/ JAVA_OPTS="-Xmx3G" ~/ngsutilsj fasta-genreads --fasta -l 150 {} \> 150bp/fasta/{@.fa}_150.fa -- fasta/hg38*.fa
