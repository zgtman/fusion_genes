#! /bin/bash

rm -f tmp_result.xls

for i in *_fusions.tsv; 

do name=${i%_out*}

awk -v name=$name '{OFS="\t"}NR>1{print name,$0}' $i >> tmp_result.xls

done

file=$(ls -1 *_fusions.tsv | awk 'NR==1{print $0}')

head -1 $file | awk '{OFS="\t"}{print "NAME",$0}' | tr -d "#" | cat - tmp_result.xls > final_arriba.xls

rm -f tmp_result.xls

