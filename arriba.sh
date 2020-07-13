#!/bin/bash

T="$(date +%s)"

source fusion_genes/config


# arriba workflow

for i in $(ls *sorted.bam)

do

conda activate arriba_env

echo "INFO: RUN ARRIBA FUSION DETECTION"

echo "INFO: Analyzing file: $i"

arriba \
	-x $i \
	-o ${i%.bam}_fusions.tsv \
	-O ${i%.bam}_fusions.discarded.tsv \
	-a "$REFERENCE" \
	-g "$GENCODE" \
	-b "$BLACK_LIST" \
	-T -P \
   	-k $COSMIC_FUSION # see section "Complete Fusion Export" at http://cancer.sanger.ac.uk/cosmic/download
#	-d structural_variants_from_WGS.tsv \


done;

conda deactivate

# concatanate all results with header to one final final report (include sample name)

touch tmp_result.xls

for i in *_fusions.tsv; 

do name=${i%_out*}

awk -v name=$name '{OFS="\t"}NR>1{print name,$0}' $i >> tmp_result.xls

done

file=$(ls -1 *_fusions.tsv | awk 'NR==1{print $0}')

head -1 $file | awk '{OFS="\t"}{print "NAME",$0}' | tr -d "#" | cat - tmp_result.xls > final_arriba.xls

rm -f tmp_result.xls

conda activate multiqc_env

multiqc . --ignore qc/

conda deactivate

mkdir qc_all_data

mv *html *json *zip multiqc* qc_all_data/

#mkdir arriba_result

#mv *fusions*tsv final_arriba.xls arriba_result/

mkdir trimming_logs

mv *trimLog* trimming_logs/

T="$(($(date +%s)-T))"

echo "INFO: Time of ARRIBA in seconds: ${T} s"
