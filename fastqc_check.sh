#!/bin/bash

T="$(date +%s)"

source fusion_genes/config

mkdir -f qc

echo "INFO: Running FASTQC..."

find *fastq.gz | parallel fastqc {} # -o qc/

echo "INFO: FASTQC finished OK"


echo "INFO: Merge all fastqc result to single MULTIQC file"

multiqc .

mv *zip *html multiqc* qc/


echo "INFO: Quality control is finished"
