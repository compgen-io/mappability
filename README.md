Genome mappability
===

Builds a mappability BedGraph file for a given genome FASTA and read-length (bp).

The pipeline works by generating a new FASTA file for each kmer in the genome. It then will align these reads to the full genome and calculate how many times the read aligns perfectly to the genome. The mappability of the read is then calculated as `1/matches`. The mappability for a given position is the mean of the mappability for every read that spans that position. So, for example, if half of the reads covering a base have a score of 1.0, but the other half have a score of 0.5, then the mappability for that base will be 0.75.

The final output the then compressed into contiguous blocks of regions with the same score in a BedGraph file (see: https://genome.ucsc.edu/goldenPath/help/bedgraph.html). 

Alignment is handled by `bwa`. Read generation and position annotation is handled by [ngsutilsj](https://github.com/compgen-io/ngsutilsj). Custom python scripts are included (`/bin`) for alignment filtering and scoring. [cgpipe](https://github.com/compgen-io/cgpipe) is used generate job scripts and optionally submit them to a batch scheduler.

There is an option for using a separate BWA index for the alignments. This options enables things like calculating mappability values for sex specific genomes without generating redundant FASTA reads. 

See example for more details.

Requires: ngsutilsj, bwa, tabix, bgzip, cgpipe, gzip, rename

The pipeline is given as a cgpipe pipline with the following options (`mappability.cgp`):

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
        --fasta genomeM.fa \
        --chrom chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22,chrX,chrY,chrM \
        --size $size \
        --threads 4 

    ./mappability.cgp \
        --outdir hg38 \
        --name hg38F \
        --fasta genomeM.fa \
        --index genomeF.fa \
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
  

## Data

Data has been pre-calculated for a variety of fragment lengths for the reference human genome. These are available here: https://github.com/compgen-io/mappability-data
