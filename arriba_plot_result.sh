#!/bin/bash

T="$(date +%s)"

full_path=$(readlink -e arriba_plot_result.sh)
source ${full_path%/*}/config


function plot() {

conda activate arriba_env

for i in *fusions.tsv

do 

echo "INFO: Plotting fusion: $i"

draw_fusions.R \
    --fusions=$i \
    --output=${i%.tsv}.pdf \
    --annotation=$GENCODE \
    --cytobands=$CYTO \
    --proteinDomains=$DOM \
    --alignments=${i%_fusions.tsv}.bam \

done

T="$(($(date +%s)-T))"

echo "INFO: Time of ARRIBA in seconds: ${T} s"

conda deactivate

}


########################
plot

