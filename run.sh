#!/bin/bash

for size in 150 100; do

./mappability.cgp \
    --outdir hg38 \
    --name hg38F \
    --fasta /N/p/spcg/resources/indexes/GRCh38.p5/genomeM.fa \
    --index /N/p/spcg/resources/indexes/GRCh38.p5/genomeF.fa \
    --chrom chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22,chrX,chrM \
    --size $size \
    --threads 4 

./mappability.cgp \
    --outdir hg38 \
    --name hg38M \
    --fasta /N/p/spcg/resources/indexes/GRCh38.p5/genomeM.fa \
    --chrom chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22,chrX,chrY,chrM \
    --size $size \
    --threads 4 

done
