#!/bin/bash

T="$(date +%s)"

source fusion_genes/config

number=$(ls *.fastq.gz | rev | cut -c 22- | rev | sort | uniq | wc -l)


for i in $(ls *.fastq.gz | rev | cut -c 22- | rev | sort | uniq)

do

echo "INFO: Found number of files: $number"
echo "INFO: Analyzing file: $i"


fastp -i ${i}_L001_R1_001.fastq.gz -I ${i}_L001_R2_001.fastq.gz -o ${i}_trim_L001_R1_001.fastq.gz -O ${i}_trim_L001_R2_001.fastq.gz -j ${i}.json -h ${i}.html -t $cpu

done;


if [ `ls -1 *trim*fastq.gz 2>/dev/null | wc -l ` -gt 0 ];

then 

echo "INFO: Trimming was performed. Creating original_fastq folder and moving original FASTQ files there"

find . -type f -iname "*trim*fastq.gz" | parallel fastqc {}

find -type f -iname "*fastq.gz" ! -iname "*trim_*fastq.gz" -exec mv {} qc/ \;

#multiqc . --ignore qc/

#mkdir trimm_fastq
#mkdir qc_filtered

#mv *trim*fastq.gz trimm_fastq/

#find . -type f \( -name "*trim*.fastq.gz*" \) -exec mv {} trimm_fastq/ \;
#mv *zip *html multiqc* *.json qc_filtered/


fi
