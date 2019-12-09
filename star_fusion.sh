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
	--genomeLoad NoSharedMemory \
	--readFilesIn ${i}_L001_R1_001.fastq.gz ${i}_L001_R2_001.fastq.gz \
	--readFilesCommand "gunzip -c" \
	--twopassMode Basic \
	--outSAMstrandField intronMotif \   # bam to tdout
	--outSAMtype BAM Unsorted \ # nesorotvany - sortuji sam samtools
	--outSAMunmapped Within \
	--outBAMcompression 0 \
	--outFilterMultimapNmax 1 --outFilterMismatchNmax 3 \
	--outFileNamePrefix ${i} \
	--chimSegmentMin 10 \
	--alignMatesGapMax 100000 \   # avoid readthru fusions within 100k
	--alignIntronMax 100000 \
    --alignSJDBoverhangMin 10 \
	--chimOutType WithinBAM SoftClip \
    --chimMultimapScoreRange 3 \
    --chimMultimapNmax 20 \
    --outSAMattrRGline ID:GRPundef \
	--chimJunctionOverhangMin 10 \
	--chimScoreMin 1 \
	--chimOutJunctionFormat 1 \ # **essential** includes required metadata in Chimeric.junction.out file.
	--chimScoreDropMax 30 \
	--chimScoreJunctionNonGTAG 0 \
	--chimScoreSeparation 1 \
	--alignSJstitchMismatchNmax 5 -1 5 5 \
	--chimNonchimScoreDropMin 10 \
	--peOverlapNbasesMin 12 \
	--peOverlapMMp 0.1 \
	--chimSegmentReadGapMax 3


done;