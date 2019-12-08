#!/bin/bash

T="$(date +%s)"

source fusion_genes/config


# arriba workflow

for i in $(ls *sorted.bam)

do

echo "INFO: RUN ARRIBA FUSION DETECTION"

echo "INFO: Analyzing file: $i"

arriba \
	-x $i \
	-o ${i%.bam}_fusions.tsv -O ${i%.bam}_fusions.discarded.tsv \
	-a "$REFERENCE" -g "$GENCODE" -b "$BLACK_LIST" \
	-T -P \
   	-k $COSMIC_FUSION # see section "Complete Fusion Export" at http://cancer.sanger.ac.uk/cosmic/download

#	-d structural_variants_from_WGS.tsv \


multiqc . --ignore qc/

mkdir qc_all_data

mv *html *json *zip multiqc* qc_all_data/

mkdir arriba_result

mv *fusions*tsv arriba_result/

done;

T="$(($(date +%s)-T))"

echo "INFO: Time of ARRIBA in seconds: ${T} s"