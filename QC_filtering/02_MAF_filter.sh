#!/bin/bash
#SBATCH -A uppmax2026-1-301
#SBATCH -J MAF_filtering
#SBATCH -t 4:00:00
#SBATCH -n 4
#SBATCH --mail-type=ALL
#SBATCH --output=./%x.%j.out

### NOT DONE ###

module load BCFtools/1.23.1-GCC-15.2.0

REF_IN=/proj/northadapt/data/reference/filtered/01_SNP_filter
TARGET_IN=/proj/northadapt/data/target/filtered/01_SNP_filter
REF_OUT=/proj/northadapt/data/reference/filtered
TARGET_OUT=/proj/northadapt/data/target/filtered

mkdir -p $REF_OUT/02_MAF_filter
mkdir -p $TARGET_OUT/02_MAF_filter

# Shared sites between ref and target

# Merge ref and target datasets and apply MAF filter
