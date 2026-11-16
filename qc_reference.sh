#!/bin/bash
#SBATCH -A uppmax2026-1-301
#SBATCH -J qc_reference
#SBATCH -t 4:00:00
#SBATCH -n 4

module load BCFtools/1.23.1-GCC-15.2.0

REF_DATA=/gorilla/proj/northadapt/reference
OUT=/gorilla/proj/northadapt/private/fynn/reference_filtered

for f in $REF_DATA/*.vcf.gz; do
    CHROM=$(basename $f .vcf.gz)
    echo "Processing $CHROM"
    bcftools view -S $REF_DATA/noflag.inds.txt -i 'MASK_1000G=1 & MAF >= 0.01 & INFO >= 0.8' -Oz $f > $OUT/$CHROM.filter.vcf.gz
done