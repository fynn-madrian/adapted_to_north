#!/bin/bash
#SBATCH -A uppmax2026-1-301
#SBATCH -J convert_target
#SBATCH -t 1:00:00
#SBATCH -n 4


module load BCFtools/1.23.1-GCC-15.2.0


bcftools view \
    -S ^remove_ids.txt \
    -Oz -o /gorilla/proj/northadapt/data/target/filtered/00_meta_exclude/target_filtered.vcf.gz \
    /gorilla/proj/northadapt/data/target/raw/merge_ibd.vcf.gz

bcftools index -t /gorilla/proj/northadapt/data/target/filtered/00_meta_exclude/target_filtered.vcf.gz