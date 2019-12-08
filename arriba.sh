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
#	-d structural_variants_from_WGS.tsv \
	-k $COSMIC_FUSION # see section "Complete Fusion Export" at http://cancer.sanger.ac.uk/cosmic/download


done;

T="$(($(date +%s)-T))"

echo "INFO: Time of ARRIBA in seconds: ${T} s"