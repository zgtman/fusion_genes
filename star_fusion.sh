#!/bin/bash

# detection gene fusion based on STAR-Fusion algorithm

T="$(date +%s)"

source fusion_genes/config

echo "RUN STAR-FUSION DETECTION"

for i in *.out.junction

do 

name=${i%Chimeric*}

echo "INFO: Processing sample: $i"

STAR-Fusion \
--genome_lib_dir $LIB_DIR \
-J $i \
--output_dir "$name"_star_fusion_out

done

#mv *Log.final.out *Log.out *Log.progress.out *Log.std.out 


T="$(($(date +%s)-T))"

echo "INFO: Time of STAR alignment in seconds: ${T} s"
