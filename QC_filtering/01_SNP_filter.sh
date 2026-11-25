#!/bin/bash
#SBATCH -A uppmax2026-1-301
#SBATCH -J SNP_filtering
#SBATCH -t 4:00:00
#SBATCH -n 4

module load BCFtools/1.23.1-GCC-15.2.0

REF=/gorilla/proj/northadapt/data/reference/raw
TARGET=/gorilla/proj/northadapt/data/target/filtered/00_meta_exclude/target_filtered.vcf.gz
REF_OUT=/gorilla/proj/northadapt/data/reference/filtered
TARGET_OUT=/gorilla/proj/northadapt/data/target/filtered

# SNP FILTERING
# biallelic SNPs, INFO, MASK for ref

#TARGET
mkdir -p $TARGET_OUT/01_SNP_filter_with_gp
bcftools view --threads 4 \
    -m2 -M2 -v snps \
    -i 'INFO >= 0.8 || SMAX(FMT/GP) >= 0.99' \
    -Oz -o $TARGET_OUT/01_SNP_filter_with_gp/target.SNPfilter.vcf.gz \
    $TARGET
bcftools index -t $TARGET_OUT/01_SNP_filter_with_gp/target.SNPfilter.vcf.gz

#REF
#uses only individuals in file noflag.inds.txt
#biallelic SNPs
mkdir -p $REF_OUT/01_SNP_filter_with_gp
for f in $REF/*.vcf.gz; do
    CHROM=$(basename $f .neo_impute_ph.vcf.gz)
    echo "Processing $CHROM"
    bcftools view --threads 4 \
        -S $REF/noflag.inds.txt -m2 -M2 -v snps -i 'MASK_1000G=1 & INFO >= 0.8 || SMAX(FMT/GP) >= 0.99' \
        -Oz -o $REF_OUT/01_SNP_filter_with_gp/$CHROM.SNPfilter.vcf.gz \
        $f
    bcftools index -t $REF_OUT/01_SNP_filter_with_gp/$CHROM.SNPfilter.vcf.gz
done
