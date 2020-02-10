#!/bin/bash

T="$(date +%s)"
start=$(date +%F\_%H_%M_%S)

source fusion_genes/config


ref=$hg38_vep


echo  "INFO: Starting annotation VCF files with reference genome: $genome and database: $database"

parallel -k "vcfanno vcfconf {} > {.}.tmpvcf" ::: *.vcf

#parallel -k "f=\"{}\"; g=\"\${f%_L001*}\"; awk -v jmeno=\"\$g\" '{OFS = \"\t\"} /^##/ {next} /^#/ {next} {split(\$9,arr1,\":\"); split (\$10,arr2,\":\"); clndn=\"CLNDN=-\"; clnrev=\"CLNREVSTAT=-\"; clnsig=\"CLNSIG=-\"; clnid=\"CLNID=-\"; rs=\"RS=-\"; if(match(\$8, /CLNDN=[^;]+/)){clndn=substr(\$8,RSTART,RLENGTH)}; if(match(\$8, /CLNREVSTAT=[^;]+/)){clnrev=substr(\$8,RSTART,RLENGTH)};if(match(\$8, /CLNSIG=[^;]+/)){clnsig=substr(\$8,RSTART,RLENGTH)};if(match(\$8, /CLNID=[^;]+/)){clnid=substr(\$8,RSTART,RLENGTH)};if(match(\$8, /RS=[^;]+/)){rs=substr(\$8,RSTART,RLENGTH)};print \$2,\$1,jmeno,\$4,\$5,arr2[1],arr2[2],arr2[3],arr2[4],arr2[5],arr2[6],arr2[7],arr2[8],arr2[9],arr2[10],arr2[11],arr2[12],arr2[13],arr2[14],clndn,clnrev,clnsig,clnid,rs}' {} | awk -v OFS=\"\t\" '{gsub(\"0/1\",\"HET\"); gsub(\"1/1\",\"HOM\")}1' | tr -d \"%\" >  {.}.parsing_vcf_tmp.tsv" ::: *.tmpvcf 

#Annotating VCF files
#echo "INFO: Annotating VCF files"



#parallel -k "vep --offline --quiet --cache_version $cache --assembly $assembly --dir $vep --refseq --no_stats --canonical --pick --force_overwrite --buffer_size 4000 --fasta $ref -i {} --tab -o STDOUT --exclude_predicted --hgvs --numbers --variant_class --sift b --af_gnomad --max_af --polyphen b --symbol --pubmed --plugin dbNSFP,$datNSFP,PROVEAN_score,PROVEAN_converted_rankscore,PROVEAN_pred,MutationTaster_score,MutationTaster_converted_rankscore,MutationTaster_pred,MutationTaster_model,MutationTaster_AAE,FATHMM_score,FATHMM_converted_rankscore,FATHMM_pred,DANN_score,DANN_rankscore,M-CAP_score,M-CAP_rankscore,M-CAP_pred,REVEL_score,REVEL_rankscore,CADD_raw,CADD_raw_rankscore,CADD_phred,LRT_score,LRT_converted_rankscore,LRT_pred,LRT_Omega,SiPhy_29way_pi,SiPhy_29way_logOdds,SiPhy_29way_logOdds_rankscore,GERP++_NR,GERP++_RS,GERP++_RS_rankscore,Ensembl_transcriptid,cds_strand,refcodon,codonpos,SIFT_score,SIFT_converted_rankscore,SIFT_pred,clinvar_review,clinvar_id,clinvar_clnsig --plugin TSSDistance | grep -v \"#\" | sed '/ /s/ /_/g' | awk -v OFS=\"\t\" '{split(\$2,arr2,\"[:-]\"); if(\$18 ~ /deletion/) print arr2[2]-1,\$0; else print arr2[2],\$0}' | cut -f1,4- | awk 'BEGIN{FS=OFS=\"\t\"}FNR==NR{for(i=2;i<=NF;i++) map[\$1]=(map[\$1] FS \$i); next}\$1 in map{print \$0,\$1,map[\$1]}' {.}.parsing_vcf_tmp.tsv - | awk 'BEGIN { FS = OFS = \"\t\" } { for(i=1; i<=NF; i++) if(\$i ~ /^ *\$/) \$i = \"-\" }; 1' > {.}.\"$cache\"_anot_tmp1.tsv" ::: *.vcf

#parallel -k "vep --offline -quiet --cache_version $cache --assembly $assembly --dir $vep --refseq --no_stats --canonical --pick --force_overwrite --buffer_size 4000 --fasta $ref -i {} --tab -o STDOUT --exclude_predicted --hgvs --numbers --variant_class --sift b --af_gnomad --max_af --polyphen b --symbol --pubmed --plugin dbNSFP,$datNSFP,PROVEAN_score,PROVEAN_converted_rankscore,PROVEAN_pred,MutationTaster_score,MutationTaster_converted_rankscore,MutationTaster_pred,MutationTaster_model,MutationTaster_AAE,FATHMM_score,FATHMM_converted_rankscore,FATHMM_pred,DANN_score,DANN_rankscore,M-CAP_score,M-CAP_rankscore,M-CAP_pred,REVEL_score,REVEL_rankscore,CADD_raw,CADD_raw_rankscore,CADD_phred,LRT_score,LRT_converted_rankscore,LRT_pred,LRT_Omega,SiPhy_29way_pi,SiPhy_29way_logOdds,SiPhy_29way_logOdds_rankscore,GERP++_NR,GERP++_RS,GERP++_RS_rankscore,Ensembl_transcriptid,cds_strand,refcodon,codonpos,SIFT_score,SIFT_converted_rankscore,SIFT_pred,clinvar_golden_stars,clinvar_rs,clinvar_clnsig --plugin TSSDistance  | grep -v \"#\" | sed '/ /s/ /_/g' | awk -v OFS=\"\t\" '{split(\$2,arr2,\"[:-]\"); if(\$18 ~ /deletion/) print arr2[2]-1,\$0; else print arr2[2],\$0}' | cut -f1,4- | awk 'BEGIN{FS=OFS=\"\t\"}FNR==NR{for(i=2;i<=NF;i++) map[\$1]=(map[\$1] FS \$i); next}\$1 in map{print \$0,\$1,map[\$1]}' {.}.parsing_vcf_tmp.tsv - | awk 'BEGIN { FS = OFS = \"\t\" } { for(i=1; i<=NF; i++) if(\$i ~ /^ *\$/) \$i = \"-\" }; 1' > {.}.\"$cache\"_anot_tmp1.tsv" ::: *.vcf

for i in *.tmpvcf

do 

echo "INFO: VEP annotation sample: $i"

vep \
--offline \
--quiet \
--cache_version 99 \
--assembly $assembly \
--dir $dir_vep \
--refseq \
--no_stats \
--canonical \
--pick \
--force_overwrite \
--buffer_size 4000 \
--fasta $REFERENCE \
--exclude_predicted \
--input_file $i \
--output_file ${i%.tmpvcf}_vep.vcf \
--vcf \
--fork 6 \
--numbers \
--hgvs \
--mane \
--af_gnomad \
--dont_skip

done;
