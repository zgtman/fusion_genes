#!/bin/bash

T="$(date +%s)"

source fusion_genes/config

ln -s fusion_genes/config
ln -s fusion_genes/fastqc_check.sh
ln -s fusion_genes/trimming.sh
ln -s fusion_genes/star_align.sh
ln -s fusion_genes/star_align1.sh
ln -s fusion_genes/arriba.sh
ln -s fusion_genes/arriba_plot_result.sh
ln -s fusion_genes/star_fusion.sh
ln -s fusion_genes/star_fusion_all.sh

### RUN SCRIPT

bash fastqc_check.sh
bash trimming.sh
bash star_align.sh ## align only for arriba
bash arriba.sh
bash arriba_plot_result.sh
#bash star_fusion.sh # not used
bash star_fusion_all.sh

unlink config
unlink fastqc_check.sh
unlink trimming.sh
unlink star_align.sh
unlink star_align1.sh
unlink arriba.sh
unlink arriba_plot_result.sh
unlink star_fusion.sh
unlink star_fusion_all.sh

T="$(($(date +%s)-T))"

echo "INFO: Time all pipeline in seconds: ${T} s"

