#!/bin/bash

# align FastQ files (STAR >=2.5.3a recommended)


source fusion_genes/config


for i in $(ls *trim*.fastq.gz | rev | cut -c 22- | rev | sort | uniq)

do

echo "INFO: RUN STAR ALIGNER"

echo "INFO: Analyzing file: $i"



STAR \
--runThreadN "$cpu" \
--genomeDir "$STAR_INDEX" \                                                                                     
--readFilesIn ${i}_L001_R1_001.fastq.gz ${i}_L001_R2_001.fastq.gz \
--outReadsUnmapped None \
--twopassMode Basic \
--readFilesCommand "gunzip -c" \
--outSAMstrandField intronMotif \  # include for potential use with StringTie for assembly
--outSAMunmapped Within \
--chimSegmentMin 12 \  # ** essential to invoke chimeric read detection & reporting **
--chimJunctionOverhangMin 12 \
--chimOutJunctionFormat 1 \   # **essential** includes required metadata in Chimeric.junction.out file.
--alignSJDBoverhangMin 10 \
--alignMatesGapMax 100000 \   # avoid readthru fusions within 100k
--alignIntronMax 100000 \
--alignSJstitchMismatchNmax 5 -1 5 5 \   # settings improved certain chimera detections
--outSAMattrRGline ID:GRPundef \
--chimMultimapScoreRange 3 \
--chimScoreJunctionNonGTAG -4 \
--chimMultimapNmax 20 \
--chimNonchimScoreDropMin 10 \
--peOverlapNbasesMin 12 \
--peOverlapMMp 0.1 




done;