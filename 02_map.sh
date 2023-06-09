#!/bin/bash

cgsub -p 4 -m 12G -t 24:00:00 --stdout logs/ --stderr logs/ --job-output 100bp/hg38F.{@.fa}.map.txt.gz --joblog joblog.txt bwa mem -a -t 4 /N/p/spcg/resources/indexes/GRCh38.p5/genomeF.fa {} \| ./calc_mappability.py \| gzip \> 100bp/hg38F.{@.fa}.map.txt.gz -- 100bp/fasta/*fa

cgsub -p 4 -m 12G -t 24:00:00 --stdout logs/ --stderr logs/ --job-output 100bp/hg38M.{@.fa}.map.txt.gz --joblog joblog.txt bwa mem -a -t 4 /N/p/spcg/resources/indexes/GRCh38.p5/genomeM.fa {} \| ./calc_mappability.py \| gzip \> 100bp/hg38M.{@.fa}.map.txt.gz -- 100bp/fasta/*fa

cgsub -p 4 -m 12G -t 24:00:00 --stdout logs/ --stderr logs/ --job-output 150bp/hg38F.{@.fa}.map.txt.gz --joblog joblog.txt bwa mem -a -t 4 /N/p/spcg/resources/indexes/GRCh38.p5/genomeF.fa {} \| ./calc_mappability.py \| gzip \> 150bp/hg38F.{@.fa}.map.txt.gz -- 150bp/fasta/*fa

cgsub -p 4 -m 12G -t 24:00:00 --stdout logs/ --stderr logs/ --job-output 150bp/hg38M.{@.fa}.map.txt.gz --joblog joblog.txt bwa mem -a -t 4 /N/p/spcg/resources/indexes/GRCh38.p5/genomeM.fa {} \| ./calc_mappability.py \| gzip \> 150bp/hg38M.{@.fa}.map.txt.gz -- 150bp/fasta/*fa


