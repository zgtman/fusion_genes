#!/bin/bash

T="$(date +%s)"

source fusion_genes/config

ln -s fusion_genes/config
ln -s fusion_genes/fastqc_check.sh
ln -s fusion_genes/trimming.sh
ln -s fusion_genes/star_align.sh
ln -s fusion_genes/arriba.sh

### RUN SCRIPT

bash fastqc_check.sh
bash trimming.sh
bash star_align.sh
bash arriba.sh



unlink config
unlink fastqc_check.sh
unlink trimming.sh
unlink star_align.sh
unlink arriba.sh

T="$(($(date +%s)-T))"

echo "INFO: Time all pipeline in seconds: ${T} s"

