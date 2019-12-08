#!/bin/bash

T="$(date +%s)"

source fusion_genes/config


# align FastQ files (STAR >=2.5.3a recommended)

for i in $(ls *trim*.fastq.gz | rev | cut -c 22- | rev | sort | uniq)

do

echo "INFO: RUN STAR ALIGNER"

echo "INFO: Analyzing file: $i"

STAR \
	--runThreadN "$cpu" \
	--genomeDir "$STAR_INDEX" --genomeLoad NoSharedMemory \
	--readFilesIn ${i}_L001_R1_001.fastq.gz ${i}_L001_R2_001.fastq.gz --readFilesCommand zcat \
	--outStd BAM_Unsorted --outSAMtype BAM Unsorted --outSAMunmapped Within --outBAMcompression 0 \
	--outFilterMultimapNmax 1 --outFilterMismatchNmax 3 \
    --outFileNamePrefix ${i} \
	--chimSegmentMin 10 --chimOutType WithinBAM SoftClip --chimJunctionOverhangMin 10 --chimScoreMin 1 --chimScoreDropMax 30 --chimScoreJunctionNonGTAG 0 --chimScoreSeparation 1 --alignSJstitchMismatchNmax 5 -1 5 5 --chimSegmentReadGapMax 3 > ${i}_out.bam


samtools sort -@ "$cpu" -m 100G -T tmp -O bam ${i}_out.bam > ${i}_out_sorted.bam
rm -f ${i}_out.bam
samtools index ${i}_out_sorted.bam

done;

T="$(($(date +%s)-T))"

echo "INFO: Time of STAR alignment in seconds: ${T} s"