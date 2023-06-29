#!/bin/bash

mkdir -p 100bp/fasta 150bp/fasta fasta logs

# we use genomeM.fa here as it has the masked PAR region of chrY. If we used 
# the normal chrY, we'd get strange mappability for those regions. Instead, 
# we just remove those regions entirely.

ngsutilsj fasta-split --template 'fasta/hg38_' /N/p/spcg/resources/indexes/GRCh38.p5/genomeM.fa

# generate 100bp and 150bp reads from the chromosomal FASTA files

cgsub -t 8:00:00 -m 4G --stdout logs/ --stderr logs/ --joblog joblog.txt --job-output 100bp/fasta/{@.fa}_100.fa JAVA_OPTS="-Xmx3G" ngsutilsj fasta-genreads --fasta -l 100 {} \> 100bp/fasta/{@.fa}_100.fa.tmp \&\& mv 100bp/fasta/{@.fa}_100.fa.tmp 100bp/fasta/{@.fa}_100.fa  -- fasta/hg38*.fa
cgsub -t 8:00:00 -m 4G --stdout logs/ --stderr logs/ --joblog joblog.txt --job-output 150bp/fasta/{@.fa}_150.fa JAVA_OPTS="-Xmx3G" ngsutilsj fasta-genreads --fasta -l 150 {} \> 150bp/fasta/{@.fa}_150.fa.tmp \&\& mv 150bp/fasta/{@.fa}_150.fa.tmp 150bp/fasta/{@.fa}_150.fa -- fasta/hg38*.fa
