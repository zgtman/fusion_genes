#!/bin/bash

# align FastQ files (STAR >=2.5.3a recommended)


source fusion_genes/config


for i in $(ls *trim*.fastq.gz | rev | cut -c 22- | rev | sort | uniq)

do

echo "INFO: RUN STAR ALIGNER"

echo "INFO: Analyzing file: $i"



STAR \
--genomeDir "$STAR_INDEX" \
--readFilesIn ${i}_L001_R1_001.fastq.gz ${i}_L001_R2_001.fastq.gz \
--twopassMode Basic \
--outStd BAM_Unsorted \
--outBAMcompression 0 \
--outFileNamePrefix ${i} \
--readFilesCommand "gunzip -c" \
--outReadsUnmapped None \
--chimSegmentMin 12 \
--chimJunctionOverhangMin 12 \
--alignSJDBoverhangMin 10 \
--alignMatesGapMax 100000 \
--alignIntronMax 100000 \
--chimSegmentReadGapMax 3 \
--alignSJstitchMismatchNmax 5 -1 5 5 \
--runThreadN ${cpu} \
--outSAMstrandField intronMotif \
--outSAMunmapped Within \
--outSAMtype BAM Unsorted \
--outSAMattrRGline ID:GRPundef \
--chimMultimapScoreRange 10 \
--chimMultimapNmax 10 \
--chimNonchimScoreDropMin 10 \
--peOverlapNbasesMin 12 \
--peOverlapMMp 0.1 \
--chimOutJunctionFormat 1 

done
