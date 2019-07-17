#!/bin/bash
source /home/jsuurvali/.bashrc


grep MODERATE ../populations.snps.vep | cut -f2 | sort > vep.moderate.list
grep HIGH ../populations.snps.vep | cut -f2 | sort > vep.high.list


for i in TU WIK CB; do
	grep $i ../../popmap | cut -f1 > keeplist.$i
	grep -v $i ../../popmap | cut -f1 > keeplist.no${i}
done


cut -f2 ../../popmap | sort -u | while read i; do
	grep $i ../../popmap | cut -f1 > keeplist.$i
	grep -v $i ../../popmap | cut -f1 > keeplist.no${i}
done


grep -P "(AB|TU|WIK|EKW|Nadia)" ../../popmap | cut -f1 > keeplist.lab
grep -Pv "(AB|TU|WIK|EKW|Nadia)" ../../popmap | cut -f1 > keeplist.wild
grep -P "(AB|TU)" ../../popmap | cut -f1 > keeplist.ABTU
grep -Pv "(AB|TU)" ../../popmap | cut -f1 > keeplist.noABTU
grep -P "(UT|CB)" ../../popmap | cut -f1 > keeplist.India
grep -Pv CB ../../popmap | cut -f1 > keeplist.noIndia

cp keeplist.wild keeplist.nolab
cp keeplist.lab keeplist.nowild


for i in keeplist.*; do
	vcftools --vcf ../populations.snps.vcf --keep $i --out freq.$i --freq
done

for i in freq.*no*.frq; do
	awk -F"[\t:]" '$8 == 0 {print $1":"$2}' $i | grep -v CHROM | sort > missing.$i
done

ls freq.* | grep -v ".no" | while read i; do
	awk -F"[\t:]" '$8 == 1 {print $1":"$2}' $i | grep -v CHROM | sort > fixed.$i
done

for i in freq.*; do
	awk -F"[\t:]" '$8 != 0 {print $1":"$2}' $i | grep -v CHROM | sort > present.$i
done


rename 's/\.freq\.keeplist//' *
