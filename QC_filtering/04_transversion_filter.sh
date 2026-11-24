#!/bin/bash
#SBATCH -A uppmax2026-1-301
#SBATCH -J transversion_filter
#SBATCH -t 4:00:00
#SBATCH -n 4
#SBATCH --mail-type=ALL
#SBATCH --output=./%x.%j.out

# Transversion filter for sanity check

module load BCFtools/1.23.1-GCC-15.2.0

REF=/gorilla/proj/northadapt/data/reference/filtered/03_MAF_filter
TARGET=/gorilla/proj/northadapt/data/target/filtered/03_MAF_filter
REF_OUT=/gorilla/proj/northadapt/data/reference/filtered/04_transversion_filter
TARGET_OUT=/gorilla/proj/northadapt/data/target/filtered/04_transversion_filter

#change to right files
bcftools view $TARGET \
  -e '(REF="C" & ALT="T") | (REF="T" & ALT="C") | (REF="G" & ALT="A") | (REF="A" & ALT="G")' \
  -Oz -o $TARGET_OUT/target.transversion.vcf.gz
  
