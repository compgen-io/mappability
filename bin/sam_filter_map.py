#!/usr/bin/env python3

import sys
import gzip

last_qname = None
best_as = -1
count = 0

for line in sys.stdin:
    if line[0] == '@':
        #sys.stdout.write(line)
        continue
    cols = line.strip().split('\t')

    qname = cols[0]

    if last_qname != qname:
        if last_qname:
            sys.stdout.write('%s\t%s\t%s\t%s\t%s\n' % (chrom, start, end, count, 1/count))
        last_qname = qname
        count = 0
        best_as = -1

    chrom = qname.split(':')[0]
    start, end = qname.split(':')[1].split('-')

    flag = int(cols[1])

    # if the read is unmapped (?!?!?!?!)
    if flag & 0x4 == 0x4 and count == 0:
        #sys.stdout.write(line)
        sys.stdout.write('%s\t%s\t%s\t0\t0\n' % (chrom, start, end))
        continue


    for tag in cols[11:]:
        spl = tag.split(':')
        if spl[0] == 'AS':
            val = int(spl[2])
            if best_as == -1:
                #sys.stdout.write(line)
                best_as = val
                count += 1
            elif val == best_as:
                #sys.stdout.write(line)
                count += 1

if last_qname:
    sys.stdout.write('%s\t%s\t%s\t%s\t%s\n' % (chrom, start, end, count, 1/count))
