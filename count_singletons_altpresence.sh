#!/bin/bash

# next lines define a function that calculates the number of singletons (minor alleles present in a single fish / present as a single allele) in every individual of a given population.
# usage: singletons <column range>

singletons () {
	grep -v "^#" populations.snps.vcf | cut -f $1 | sed -r 's/(.)\/(.):[^\t]*(\t|$)/\1\2\3/g' | \
		grep "1" | grep -vP "1.*\t.*1" | sed -re 's/[01]1/1/g' -e 's/(00|\.\/\.)/0/g' | \
		Rscript -e 't(as.data.frame(lapply(read.csv("stdin", sep = "\t", header = F),sum)))' | \
		awk 'NR > 1 {print $2}' >> tmp1

	grep -v "^#"  populations.snps.vcf | cut -f $1 | sed -r 's/(.)\/(.):[^\t]*(\t|$)/\1\2\3/g' | \
		grep "1" | grep -vP "0.*\t.*0" | sed -re 's/0[01]/1/g' -e 's/(11|\.\/\.)/0/g' | \
		Rscript -e 't(as.data.frame(lapply(read.csv("stdin", sep = "\t", header = F),sum)))' | \
		awk 'NR > 1 {print $2}' >> tmp2

        grep -v "^#" populations.snps.vcf | cut -f $1 | sed -r 's/(.)\/(.):[^\t]*(\t|$)/\1\2\3/g' | \
                grep "1" | grep -vP "1.*1" | sed -re 's/01/1/g' -e 's/(00|\.\/\.)/0/g' | \
                Rscript -e 't(as.data.frame(lapply(read.csv("stdin", sep = "\t", header = F),sum)))' | \
                awk 'NR > 1 {print $2}' >> tmp3

        grep -v "^#"  populations.snps.vcf | cut -f $1 | sed -r 's/(.)\/(.):[^\t]*(\t|$)/\1\2\3/g' | \
                grep "1" | grep -vP "0.*0" | sed -re 's/01/1/g' -e 's/(11|\.\/\.)/0/g' | \
                Rscript -e 't(as.data.frame(lapply(read.csv("stdin", sep = "\t", header = F),sum)))' | \
                awk 'NR > 1 {print $2}' >> tmp4
}


rm tmp*

singletons "10-49"
singletons "50-97"
singletons "98-112"
singletons "113-132"
singletons "133-146"
singletons "147-204"
singletons "205-253"
singletons "254-284"
singletons "285-309"
singletons "310-328"
singletons "329-336"
singletons "337-347"
singletons "348-354"
singletons "254-328"


grep -v "^##" populations.snps.vcf | cut -f254-328 | \
	sed -re 's/.\/(.):[^\t]*(\t|$)/\1\2/g' -e 's/\.(\/\.)?/0/g' | \
	Rscript -e 't(as.data.frame(lapply(read.csv("stdin", sep = "\t", header = T),sum)))' | sed '1d' > tmp

paste tmp tmp1 tmp2 tmp3 tmp4 | sed '1s/^/\#fish\tnonref_allele_present\tnonref_singlefish\tref_singlefish\tnonref_singletons\tref_singletons\n/' > indv_all_counts.tsv
rm tmp*
