#!/bin/bash

T="$(date +%s)"

source fusion_genes/config

echo "STAR-FUSION ALL IN WORKFLOW"

for i in $(ls *trim*.fastq.gz | rev | cut -c 22- | rev | sort | uniq)

do

conda activate star-fusion_env

name=${i%_L001*}

echo "INFO: Analyzing file: $i"


STAR-Fusion \
--genome_lib_dir $LIB_DIR \
--left_fq ${i}_L001_R1_001.fastq.gz \
--right_fq ${i}_L001_R2_001.fastq.gz \
--output_dir "$name"_star_fusion_output

done

for i in *_fusion_output; do mv $i/star-fusion.fusion_predictions.tsv "$i"/${i%_trim_star*}_fusion_prediction.tsv; done

conda deactivate

T="$(($(date +%s)-T))"

echo "INFO: Time of STAR-FUSION ALL-IN-ONE in seconds: ${T} s"
