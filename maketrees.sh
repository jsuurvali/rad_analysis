#! /bin/bash
source ~/.bashrc


grep -v tacks populations.fixed.phylip > pops.fixed.phylip
grep -v tacks populations.var.phylip > pops.var.phylip

raxmlHPC-PTHREADS-SSE3 -s pops.fixed.phylip -n fixed -m GTRCAT -k -V -T 8 -x 77 -p 77 -f a -N 1000
raxmlHPC-PTHREADS-SSE3 -s pops.var.phylip -n var -m GTRCAT -k -V -T 8 -x 77 -p 77 -f a -N 1000
