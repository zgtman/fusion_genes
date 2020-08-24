# Fusion genes workflow
#### based on STAR, Arriva and STAR-FUSION algorithms
###### Created by Ales Vicha and Petr Broz
#### First install [Conda](https://www.anaconda.com/distribution/) - Python version 3.7

##### INSTALATION INSTRUCTION:  
*sudo yum install parallel*  
*conda create -n arriba_env -c bioconda arriba*
*wget https://anaconda.org/bioconda/star-fusion/1.9.0/download/noarch/star-fusion-1.9.0-1.tar.bz2*
*conda create -n star-fusion_env  star-fusion-1.9.0-1.tar.bz2*
*conda install -c bioconda star=2.7.2b*
*conda install -c bioconda fastp*  
##### ADDITIONAL INSTALLATION FOR STAR FUSION WORKFLOW  

conda install picard gatk4 vcfanno fastqc
conda create -n samtools_env -c bioconda samtools openssl=1.0

###### donwload annotation package for GRCh38: wget https://data.broadinstitute.org/Trinity/CTAT_RESOURCE_LIB/GRCh38_gencode_v32_CTAT_lib_Dec062019.plug-n-play.tar.gz
###### TODO  
###### **Test data to STAR-FUSION**  
###### **Parsing Result and concatanate to one**  
  
