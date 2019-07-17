#!/bin/bash

rm GCfreqs.tsv
for i in *.frq; do
        awk -F'[\t:]' 'BEGIN {OFS="\t"} NR > 1 && $8 != 0 && $8 != 1 && $8 !~ /nan/ {print FILENAME,$5$7,$1,$2,$4,$8}' $i | \
        sed -re 's/\t(AC|TC|AG|TG)\t/\tAT-GC\t/' -e 's/\t(CA|CT|GA|GT)\t/\tGC-AT\t/' -e 's/\t(AT|TA)\t/\tAT-AT\t/' -e 's/\t(GC|CG)\t/\tGC-GC\t/' -e 's/\.frq//'  >> GCfreqs.tsv
done
