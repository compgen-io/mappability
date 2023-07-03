Mappability
===

Builds a mappability bedgraph file for a genome and base-size

There is an option for using a separate BWA index for the alignments. This options enables things like 
calculating mappability values for sex specific genomes without generating redundant FASTA reads. 

See example for more details.

Requires: ngsutilsj, bwa, tabix, bgzip

The pipeline is given as a cgpipe pipline with the following options:

    mappability.cgp

    Required:
      --fasta genome.fa      Genome FASTA file
      --size N               Size of the reads to use (ex: 100, 150)
      --name val             Name of the genome (hg38, mm10, etc)

    Options:
      --outdir val           Output directory (default to --name)
                             Output will be written to ${outdir}/${size}bp/${name}_${size}.map.bg.gz

      --index genome.fa      BWA indexed FASTA file (default to --fasta)
      --chrom chr1,chr2...   Comma separated list of chromosomes to include (by default uses all)


    BWA options:
      --threads N            Threads to use

Example usage (`run.sh`):

    #!/bin/bash

    for size in 100 150; do

    ./mappability.cgp \
        --outdir hg38 \
        --name hg38M \
        --fasta /N/p/spcg/resources/indexes/GRCh38.p5/genomeM.fa \
        --chrom chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22,chrX,chrY,chrM \
        --size $size \
        --threads 4 

    ./mappability.cgp \
        --outdir hg38 \
        --name hg38F \
        --fasta /N/p/spcg/resources/indexes/GRCh38.p5/genomeM.fa \
        --index /N/p/spcg/resources/indexes/GRCh38.p5/genomeF.fa \
        --chrom chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22,chrX,chrM \
        --size $size \
        --threads 4 

    done

Example output:

    chr1	10000	10623	1.0
    chr1	10623	10624	0.9966666666666667
    chr1	10624	10625	0.9933333333333333
    chr1	10625	10626	0.99
    chr1	10626	10627	0.9866666666666667
    chr1	10627	10628	0.9803921568627452
    chr1	10628	10629	0.9741176470588235
    chr1	10629	10630	0.967843137254902
    chr1	10630	10631	0.9615686274509805
    chr1	10631	10632	0.955294117647059
  