#!/bin/bash

T="$(date +%s)"

source fusion_genes/config

ln -s fusion_genes/config
ln -s fusion_genes/fastqc_check.sh
ln -s fusion_genes/trimming.sh

### RUN SCRIPT

bash fastqc_check.sh
bash trimming.sh





unlink config
unlink fastqc_check.sh
unlink trimming.sh



T="$(($(date +%s)-T))"

echo "INFO: Time all pipeline in seconds: ${T} s"

