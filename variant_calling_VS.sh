#!/bin/bash

T="$(date +%s)"

source fusion_genes/config

echo "INFO: Analysis strarting..."

for k in *trim_out_sorted.bam;

do

echo "INFO: Creating mpileup for sample: $k"

samtools mpileup -B -Q 0 -q 0 -d 2000 -f $REFERENCE $k > ${k%.bam}.mpileup

#parallel -k "samtools mpileup -B -q $base -Q $mapping -f $REFERENCE {} -o {.}.mpileup" ::: *trim_out_sorted.bam


done

T1="$(($(date +%s)-T))"
echo "Time mpileup is: ${T1}"

for i in *.mpileup;

do

echo "INFO: Variant Calling for sample $i"

echo "INFO: SNP CALLING"

varscan mpileup2snp $i --min-coverage $min_coverage --min-reads2 $min_reads --min-avg-qual $min_qual --min-var-freq $min_var_freq --strand-filter $strand_filter --p-value $p_value --output-vcf 1 > ${i%.mpileup}.snp.vcf

echo "INFO: INDEL CALLING"

varscan mpileup2indel $i --min-coverage $min_coverage --min-reads2 $min_reads --min-avg-qual $min_qual_indel --min-var-freq $min_var_freq --strand-filter $strand_filter --p-value $p_value --output-vcf 1 > ${i%.mpileup}.indel.vcf

echo "INFO: MERGE SNP+INDELs FILES"

picard MergeVcfs I= ${i%.mpileup}.snp.vcf  I= ${i%.mpileup}.indel.vcf O= ${i%.mpileup}.vcf D= $dict

rm -f ${i%.mpileup}.snp.vcf ${i%.mpileup}.indel.vcf

rm -rf $i

done;

T2="$(($(date +%s)-TT))"
echo "Time varscan is: ${T2}"



#mkdir variants_$genome

for k in *.vcf; do echo $k; grep -v "#" $k | wc -l; done | paste - - > number_vcf.txt

#mv *.vcf variants_$genome


stop="$(date +%D---%T)"
T="$(($(date +%s)-T))"

echo "Aanylsis finished in ${T}"


