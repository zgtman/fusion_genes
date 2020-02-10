#!/bin/bash

## Version 1.0 to zoom project

T="$(date +%s)"

source fusion_genes/config

# CALLING SNP BY GATK

mkdir tmp

for x in *trim_out_sorted.bam;

do

name=${x%_trim*}

echo "INFO: Calling SNP-INDELs VCF by GATK"
echo "INFO: Processing sample: $x"


#     Base recalibration (fixes them so they better reflect the probability of mismatching the genome).
#     Analyze patterns of covariation in the sequence.
#    echo "INFO: STEP1: Performing base recalibration"
#    gatk --java-options "-Xmx8G -Djava.io.tmpdir=$PWD/tmp -XX:ParallelGCThreads=$cpu" BaseRecalibrator -R $REFERENCE -I $x -O recal_data.table -known-sites $dbsnp -known-sites $db_1000G -known-sites $db_mills

#     Apply recalibration to the sequence data.
#    echo "INFO: STEP2: Applying recalibration to the sequence data"
#   gatk --java-options "-Xmx8G -Djava.io.tmpdir=$PWD/tmp -XX:ParallelGCThreads=$cpu" ApplyBQSR -R $hg38 -I $x --bqsr-recal-file recal_data.table -O ${x%.bam}.recal.bam
    
#     Call variants

echo "INFO: Adding read group..."

picard AddOrReplaceReadGroups \
I= $x \
O= ${x%.bam}_rg.bam \
RGID= $name \
RGLB= rnaseq \
RGPL= illumina \
RGPU= unit1 \
RGSM= $name \

echo "INFO: Indexing..."

samtools index ${x%.bam}_rg.bam

gatk --java-options "-Xmx"$memory"G -Djava.io.tmpdir=$PWD/tmp -XX:ParallelGCThreads=$cpu" HaplotypeCaller -R $REFERENCE -I ${x%.bam}_rg.bam --max-alternate-alleles 1 -O ${x%.bam}.raw.vcf --dbsnp $dbsnp

 # --dbsnp $dbsnp # output: GVCF with blocks, to generate non-block data use -ERC BP_RESOLUTION
    
#gatk VariantsToTable -V ${x%.bam}.raw.vcf -F CHROM -F POS -F POS -F REF -F ALT -GF DP -GF AD -GF GT -O ${x%.bam}.raw.snps.g_tmp.bed

done;


T="$(($(date +%s)-T))"


echo "INFO: Time of Calling SNP-INDELs GVCF by GATK is ${T} s"
