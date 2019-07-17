#! /bin/bash

BAMDIR=$1
POPLIM=$2


mkdir gstacks snp_random snp_all


gstacks -I ${BAMDIR} -M popmap -O gstacks -t 8
###  --remove-unpaired-reads --remove-pcr-duplicates ### uncomment this if working with paired reads


populations -P gstacks -M popmap -O snp_random -p ${POPLIM} -r 0.8 -t 8 -e sbfI --lnl_lim -10 --no_hap_exports --write_random_snp --merge_sites --ordered_export --vcf --structure


populations \
-P gstacks -M popmap \
-O snp_all \
-p ${POPLIM} -r 0.8 -t 8 -e sbfI --lnl_lim -10 \
--fstats -k --fst_correction p_value --bootstrap --hwe \
--merge_sites --ordered_export \
--vcf --genepop --structure --radpainter --plink --phylip --phylip_var \
--fasta_loci --fasta_samples
