#!/bin/bash
#SBATCH -A uppmax2026-1-301
#SBATCH -J SNP_filtering
#SBATCH -t 12:00:00
#SBATCH -n 4

### NOT DONE ###

module load BCFtools/1.23.1-GCC-15.2.0

REF_IN=/proj/northadapt/data/reference/filtered/01_SNP_filter
TARGET_IN=/proj/northadapt/data/target/filtered/02_SNP_filter
REF_OUT=/proj/northadapt/data/reference/filtered
TARGET_OUT=/proj/northadapt/data/target/filtered

mkdir -p $REF_OUT/02_MAF_filter
mkdir -p $TARGET_OUT/03_MAF_filter

# Shared sites between ref and target

# Merge ref and target datasets and MAF filter


# RELATEDNESS FILTERING
# Filter out related individuals from the target dataset (third degree))

# Filter out related individuals from the ref dataset (third degree) (optional)



# Seperarte the merged dataset into ref and target datasets amd save

# Transversion filter for sanity check, save datasets
