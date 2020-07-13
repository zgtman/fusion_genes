# Fusion genes workflow
#### based on STAR, Arriva and STAR-FUSION algorithms
###### Created by Ales Vicha and Petr Broz
#### First install [Conda](https://www.anaconda.com/distribution/) - Python version 3.7

##### INSTALATION INSTRUCTION:  
*sudo yum install parallel*  
*conda create -n arriba_env -c bioconda arriba*
*conda create -n star_env -c bioconda/label/cf201901 star*  
*conda install -c bioconda fastp*  
##### ADDITIONAL INSTALLATION FOR STAR FUSION WORKFLOW  
*conda create -n star-fusion_env -c bioconda/label/cf201901 star-fusion* 

conda install picard samtools gatk4 vcfanno fastqc
###### donwload annotation package for GRCh38: wget https://data.broadinstitute.org/Trinity/CTAT_RESOURCE_LIB/GRCh38_gencode_v32_CTAT_lib_Dec062019.plug-n-play.tar.gz
###### TODO  
###### **Test data to STAR-FUSION**  
###### **Parsing Result and concatanate to one**  
  
