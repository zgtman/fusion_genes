#!/bin/bash

T="$(date +%s)"

source fusion_genes/config

mkdir qc_filtered
mkdir fastq_filtered

number=$(ls *.fastq.gz | rev | cut -c 22- | rev | sort | uniq | wc -l)


for i in $(ls *.fastq.gz | rev | cut -c 22- | rev | sort | uniq)

do

echo "INFO: Found number of files: $number"
echo "INFO: Analyzing file: $i"


fastp -i ${i}_L001_R1_001.fastq.gz -I ${i}_L001_R2_001.fastq.gz -o ${i}_trim_L001_R1_001.fastq.gz -O ${i}_trim_L001_R2_001.fastq.gz -j ${i}.json -h ${i}.html -t $cpu -M 18

done;

find *trim*fastq.gz | parallel fastqc {}

multiqc . --ignore qc/

mv *zip *html multiqc* *.json qc_filtered/


if [ `ls -1 *trim*fastq.gz 2>/dev/null | wc -l ` -gt 0 ];

then 

echo "INFO" Trimming was performed. Creating original_fastq folder and moving original FASTQ files there"


fi

#mv *trim*fastq.gz fastq_filtered/