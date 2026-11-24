#!/bin/bash
#SBATCH -A uppmax2026-1-301
#SBATCH -J remove_related
#SBATCH -t 1:00:00
#SBATCH -n 4


module load BCFtools/1.23.1-GCC-15.2.0

base=/gorilla/proj/northadapt/data/target/filtered
out=$base/02_related_filter

in=$base/01_SNP_filter/target.SNPfilter.vcf.gz

bcftools view \
    -S ^/home/fynn/adapted_to_north/QC_filtering/king_results/exclude_target_ids.txt \
    -Oz -o $out/target_filtered.vcf.gz \
    $in

bcftools index -t $out/target_filtered.vcf.gz