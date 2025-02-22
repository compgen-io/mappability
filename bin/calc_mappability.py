#!/usr/bin/env python3
#
# Given a mappability txt file (chrom, start, end, num_hits, score), calculate the mappability for each
# position on a given chromosome. The final output should be a bed-graph file (chrom, start, end, 
# mean score), where all consecutive positions that have the same score are collapsed.
#
# The idea is that this file could then be used to generate bin-level scores for arbitrary regions
# in a BED input file.
#

import sys
import gzip


def mean(vals):
    acc = 0
    count = 0

    for val in vals:
        acc += val
        count += 1

    return acc / count


class Buffer(object):
    def __init__(self, out):
        self._out = out
        self._cur_chrom = ""
        self._cur_start = -1
        self._cur_end = -1
        self._cur_val = -1

    def add(self, chrom, pos, val):
        if self._cur_chrom == chrom and self._cur_val == val:
            self._cur_end = pos
            return

        self.flush()

        self._cur_chrom = chrom
        self._cur_start = pos
        self._cur_end = pos
        self._cur_val = val

    def flush(self):
        if self._cur_chrom:
            self._out.write('%s\t%s\t%s\t%s\n' % (self._cur_chrom, self._cur_start, self._cur_end+1, self._cur_val))


class PositionScore(object):
    def __init__(self, chrom, pos, score):
        self._scores = [score]
        self._chrom = chrom
        
        # this is a zero-based coordinate
        self._pos = pos

    def add_score(self, score):
        self._scores.append(score)

    def get_score(self):
        # truncate score to 4 decimal points.
        return round(mean(self._scores), 4)

    def write(self, out):
        out.write('%s\t%s\t%s\t%s\t%s\n' % (self._chrom, self._pos, self._pos+1, self.get_score(), len(self._scores)))


pos_scores = []
buffer = None

if sys.argv[1] == '-bg':
    buffer = Buffer(sys.stdout)
    fnames = sys.argv[2:]
else:
    fnames = sys.argv[1:]

for fname in fnames:
    if fname == '-':
        f = sys.stdin
    else:
        sys.stderr.write('%s\n' % fname)
        f = gzip.open(fname, 'rt')

    cur_chrom = None

    for line in f:
        cols = line.strip().split('\t')
        chrom = cols[0]
        start = int(cols[1])
        end = int(cols[2])
        hits = int(cols[3])
        score = float(cols[4])

        if cur_chrom != chrom and cur_chrom:
            for ps in pos_scores:
                if buffer:
                    buffer.add(ps._chrom, ps._pos, ps.get_score())
                else:
                    ps.write(sys.stdout)
            pos_scores = []
            cur_chrom = chrom

        keep = []
        valid_pos = set()

        for ps in pos_scores:
            if ps._pos >= start and ps._pos < end:
                ps.add_score(score)
                keep.append(ps)
                valid_pos.add(ps._pos)
            else:
                if buffer:
                    buffer.add(ps._chrom, ps._pos, ps.get_score())
                else:
                    ps.write(sys.stdout)

        for pos in range(start, end): # this is a zero-based range, so don't add one
            if not pos in valid_pos:
                ps = PositionScore(chrom, pos, score)
                keep.append(ps)

        pos_scores = keep

    for ps in pos_scores:
        if buffer:
            buffer.add(ps._chrom, ps._pos, ps.get_score())
        else:
            ps.write(sys.stdout)

    if f != sys.stdin:
        f.close()

if buffer:
    buffer.flush()
