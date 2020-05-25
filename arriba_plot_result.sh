#!/bin/bash

T="$(date +%s)"

full_path=$(readlink -e arriba_plot_result.sh)
source ${full_path%/*}/config
CYTO=${full_path%/*}/bed_files/cytobands_hg38_GRCh38_2018-02-23.tsv
DOM=${full_path%/*}/bed_files/protein_domains_hg38_GRCh38_2018-03-06.gff3


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

