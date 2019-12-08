#! /bin/bash

# Created by Petr Broz - bioxsys s.r.o.


function usage()
{
    echo ""
    echo "This script check quality of FASTQ fieles, provide trimming and found genes fusions from RNA-seq"
    echo "Usage: ./gene_fusion.sh [OPTIONS]"
    echo "Example: ./gene_fusion.sh -r=/home/illumina/runs/AHCLGJDSXX -o=/home/illumina/runs/output"
    echo "Options:"
    echo -e "\t-h|--help \t\t\tprint this help"
    echo ""
    echo -e "REQUIRED parameters:"
    echo -e "\t-fq=PATH|--fastq=PATH \tpath to illumina FASTQ.gz files (containing FASTQ.gz)"
    echo -e "\t-o=PATH|--output=PATH \t\tpath where output folder will be created"
    echo ""
    echo -e "OPTIONAL QC parameters:"
    echo -e "\t-fastqc| \t\tprovide fastqc analysis"
    echo -e "\t-trim| \t\tprovide trimming FASTQ files based on FASTQC result"
    echo -e "\t-fusion| \t\tprovide alignment to reference genome and find genes-fusion candidates"
}


if [ "$#" -eq 0 ] # checking the number of parameters
then

  echo "ERROR: Options were not set "
  usage 
  exit 1
fi  

for key in "$@"
do
case $key in
    -h|--help)
    usage
    ;;
    -fq=*|--fastq=*)
    FASTQ_FOLDER="${key#*=}"
    ;;
    -o=*|--output=*)
    OUTPUT="${key#*=}"
     ;;
    -fastqc|--fastqc)
    FASTQC=YES
    ;;
    -trim=*|--trim)
    TRIM=YES
    ;;
    -fusion=*|--fusion)
    FUSION=YES
    ;;
    *)    # unknown option
     echo "ERROR:  unknown parameter $key"
     usage 
     exit 1
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters


# Handling errors & warnings


if ! ls -d $FASTQ_FOLDER/*fastq.gz &> /dev/null # check path to InterOp folder
then
  
  echo "ERROR:  FASTQ files in folder was not found"
  echo "Check the desination: $FASTQ_FOLDER"
  usage 
  exit 1
fi


if ! ls -d $OUTPUT &> /dev/null # check path to output folder
then
  
  echo "ERROR:  The path to the output folder does not exist"
  echo "The output folder wil be located in $PWD"
  
  OUTPUT=$PWD
fi

if [ -z "$BAMFILE" ]
then

  echo "WARNING:  The path to BAM file(s) was not provided and the BAM QC metrics will not be collected"
fi

if [ -n "$BAMFILE" ]
then

  ls $BAMFILE/*.bam > /dev/null 2>&1 # Check existence of BAM file(s) here
  if [ "$?" -ne 0 ]
    then
    
      echo "ERROR:  Attempted to collect BAM QC metrics, however no  BAM file(s) were found in the selected path"
      echo "Check the desination: $BAMFILE"
    usage
    exit 1
  fi
  
  ls $BAMFILE/*.bam > path.tmp
  
  while read line # Check BAM file(s) for invalid characters
  do
  
    zavinac=$(samtools view -H $line | head -c1)
    if [ "$zavinac" != "@" ] 
    then

      echo "ERROR:  Attempted to collect BAM QC metrics, however invalid  BAM file(s) were found in the selected path"
      echo "Check the desination: $BAMFILE"
      usage
      exit 1
    fi
  done < path.tmp
  rm path.tmp
fi

if [ -n "$BAMFILE" ] && [ -z "$GENOME" ]
then

  echo "ERROR:  Attempted to collect BAM QC metrics, however the path to the reference genome was not provided"
  usage
  exit 1
fi

if [ -n "$BAMFILE" ] && [ -z "$TARGETS" ]
then

  echo "ERROR:  Attempted to collect BAM QC metrics, however the path to the targets file was not provided"
  usage
  exit 1
fi

if [ -n "$BAMFILE" ] && [ -z "$BAITS" ]
then

  echo "WARNING:  Attempted to collect BAM QC metrics, however the path to the baits file was not provided"
  echo "INFO:  The targets file will be used instead of baits file"
  BAITS="$TARGETS"
fi


if [ -n "$BAMFILE" ]
then

  if ! grep "chr*" $GENOME > /dev/null 2>&1 # Check existence of reference genome in FASTA format
    then

      echo "ERROR:  Attempted to collect BAM QC metrics, however invalid reference genome was not found in the selected path"
      echo "Check the file: $GENOME"
      usage
      exit 1
  fi
fi

if [ -z "$FASTQ" ]
then

  echo "WARNING:  The path to FASTQ file(s) was not provided and the FASTQ QC metrics will not be collected"
fi  

if [ -n "$FASTQ" ]
then

  ls $FASTQ/*.fastq.gz &> /dev/null # check path to FASTQ files
  if [ "$?" -ne 0 ]
    then
    
      echo "ERROR:  Attempted to collect FASTQ QC metrics, however no  FASTQ file(s) were found in the selected path"
      echo "Check the desination: $FASTQ"
      usage
      exit 1
  fi
fi

if [ -z "$FILTER" ] && [ -n "$BAMFILE" ] # setting default option for library prep (hybridization capture)
then

  FILTER=YES
  echo "INFO:  The selected library preparation mode is hybridization capture"
  
elif [ "$FILTER" == "NO" ]
then

  echo "INFO:  The selected library preparation mode is amplicon"
fi  

if [ -z "$COVERAGE" ]
then

  echo "WARNING:  COVERAGE QC metrics will not be collected"
fi  

if [ -n "$COVERAGE" ]
then

  ls $COVERAGE/*basecov_annotated* &> /dev/null # check path to coverage files
  
  if [ "$?" -ne 0 ]
  then
  
    echo "ERROR:  Attempted to collect COVERAGE QC metrics, however no  coverage file(s) were found in the selected path"
    echo "Check the desination: $COVERAGE"
    usage
    exit 1
  fi
fi  



# VARIABLES
start=$(date +%F\_%H_%M_%S)
error="$start"_error_log.txt
exec > $error 2>&1
