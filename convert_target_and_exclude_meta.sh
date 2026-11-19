#!/bin/bash
#SBATCH -A uppmax2026-1-301
#SBATCH -J convert_target
#SBATCH -t 1:00:00
#SBATCH -n 4

module load PLINK/2.0.0-a.6.20-gfbf-2024a

#plink --vcf /gorilla/proj/northadapt/private/data/merge_ibd.vcf.gz \
#      --double-id \
#      --make-bed \
#      --out /gorilla/proj/northadapt/private/fynn/target

plink --bfile /gorilla/proj/northadapt/private/fynn/target \
      --remove meta_remove.txt \
      --make-bed \
      --out /gorilla/proj/northadapt/data/target/target_filtered