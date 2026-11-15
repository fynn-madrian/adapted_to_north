#!/bin/bash
#SBATCH -A uppmax2026-1-301
#SBATCH -J pruna_pca
#SBATCH -t 1:00:00
#SBATCH -n 4

OUT=/gorilla/proj/northadapt/private/fynn/target

module load PLINK/2.0.0-a.6.20-gfbf-2024a
module load BCFtools/1.3.1-GCC-13.3.0

bcftools view -m2 -M2 -v snps /gorilla/proj/northadapt/private/data/merge_ibd.vcf.gz \
  -e '(REF="C" & ALT="T") | (REF="T" & ALT="C") | (REF="G" & ALT="A") | (REF="A" & ALT="G")' \
  -Oz -o $OUT/data.filtered.vcf.gz


plink --vcf $OUT/data.filtered.vcf.gz \
    --double-id \
    --allow-extra-chr \
    --set-missing-var-ids @:# \
    --geno 0.1 \
    --maf 0.05 \
    --make-bed \
    --out $OUT/data



# Find a set of roughly independent SNPs
plink --bfile $OUT/data --allow-extra-chr \
      --indep-pairwise 50 10 0.1 \
      --out $OUT/data

# Run the PCA on the pruned SNPs
plink --bfile $OUT/data --allow-extra-chr \
      --extract $OUT/data.prune.in \
      --pca 10 \
      --out $OUT/pca