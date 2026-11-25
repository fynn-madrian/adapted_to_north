#!/bin/bash
#SBATCH -A uppmax2026-1-301
#SBATCH -J transversion_filter
#SBATCH -t 2:00:00
#SBATCH -n 4
#SBATCH --array=1-22
#SBATCH --mail-type=ALL
#SBATCH --output=./TV_log/%x.%j.out

# Transversion filter for sanity check
set -euo pipefail
module load BCFtools/1.23.1-GCC-15.2.0

REF_IN=/gorilla/proj/northadapt/data/reference/filtered/03_MAF_filter
TARGET_IN=/gorilla/proj/northadapt/data/target/filtered/03_MAF_filter
REF_OUT=/gorilla/proj/northadapt/data/reference/filtered/04_transversion_filter
TARGET_OUT=/gorilla/proj/northadapt/data/target/filtered/04_transversion_filter

CHR=$SLURM_ARRAY_TASK_ID
THREADS=4

REF_FILE=$REF_IN/${CHR}.MAF.vcf.gz        #double check these
TARGET_FILE=$TARGET_IN/${CHR}.MAF.vcf.gz

bcftools view $REF_FILE \
  -e '(REF="C" & ALT="T") | (REF="T" & ALT="C") | (REF="G" & ALT="A") | (REF="A" & ALT="G")' \
  -Oz -o $REF_OUT/ref.${CHR}.transversion.vcf.gz
bcftools index -t $REF_OUT/ref.${CHR}.transversion.vcf.gz

bcftools view $TARGET_FILE \
  -e '(REF="C" & ALT="T") | (REF="T" & ALT="C") | (REF="G" & ALT="A") | (REF="A" & ALT="G")' \
  -Oz -o $TARGET_OUT/target.${CHR}.transversion.vcf.gz
bcftools index -t $TARGET_OUT/target.${CHR}.transversion.vcf.gz

