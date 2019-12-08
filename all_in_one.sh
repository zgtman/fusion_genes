#!/bin/bash

T="$(date +%s)"

source fusion_genes/config

ln -s fusion_genes/config
ln -s fusion_genes/fastqc_check.sh


### RUN SCRIPT

bash fastqc_check.sh






unlink config
unlink fastqc_check.sh




T="$(($(date +%s)-T))"

echo "INFO: Time all pipeline in seconds: ${T} s"

