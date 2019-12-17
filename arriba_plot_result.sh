#!/bin/bash

T="$(date +%s)"

source fusion_genes/config


for i in *fusions.tsv

do 

echo "INFO: Plotting fusion: $i"

draw_fusions.R \
    --fusions=$i \
    --output=${i%.tsv}.pdf \
    --annotation=$GENCODE \
    --cytobands=$CYTO \
    --proteinDomains=$DOM
#    --alignments=/home/broz/ssd/arriba_workflow/test/LU5-Doc_S8_trim_out_sorted.bam \


done


T="$(($(date +%s)-T))"

echo "INFO: Time of ARRIBA in seconds: ${T} s"

