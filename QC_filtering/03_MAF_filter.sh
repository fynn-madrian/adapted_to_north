#!/bin/bash
#SBATCH -A uppmax2026-1-301
#SBATCH -J MAF_filtering
#SBATCH -t 4:00:00
#SBATCH -n 4
#SBATCH --array=1-22
#SBATCH --mail-type=ALL
#SBATCH --output=./%x.%j.out

set -euo pipefail
module load BCFtools/1.23.1-GCC-15.2.0

CHR=$SLURM_ARRAY_TASK_ID
MAF_MIN=0.01
THREADS=4

REF_IN=/gorilla/proj/northadapt/data/reference/filtered/01_SNP_filter
TARGET_IN=/gorilla/proj/northadapt/data/target/filtered/02_related_filter
REF_OUT=/gorilla/proj/northadapt/data/reference/filtered/03_MAF_filter
TARGET_OUT=/gorilla/proj/northadapt/data/target/filtered/03_MAF_filter

REF_FILE=$REF_IN/${CHR}.SNPfilter.vcf.gz        
TARGET_FILE=$TARGET_IN/target_filtered.vcf.gz

TMP=$TARGET_OUT/03_MAF_filter/tmp_chr${CHR}
mkdir -p $TMP

count() { bcftools index -n "$1"; }

# 1. This chromosome, all samples
bcftools view --threads $THREADS -Oz -o $TMP/ref.vcf.gz $REF_FILE
bcftools view -r $CHR --threads $THREADS -Oz -o $TMP/target.vcf.gz $TARGET_FILE
bcftools index -t $TMP/ref.vcf.gz
bcftools index -t $TMP/target.vcf.gz

# 2. Shared sites (same position, REF and ALT)
bcftools isec -n=2 -c none -w1,2 -Oz -p $TMP/isec $TMP/ref.vcf.gz $TMP/target.vcf.gz
bcftools index -t $TMP/isec/0000.vcf.gz
bcftools index -t $TMP/isec/0001.vcf.gz

bcftools query -l $TMP/isec/0000.vcf.gz > $TMP/ref_samples.txt
bcftools query -l $TMP/isec/0001.vcf.gz > $TMP/target_samples.txt

# 3. Merge, recompute allele counts and frequencies, MAF filter
bcftools merge -m none --threads $THREADS -Ou $TMP/isec/0000.vcf.gz $TMP/isec/0001.vcf.gz \
  | bcftools annotate -x INFO,FORMAT -Ou \
  | bcftools +fill-tags -Ou -- -t AN,AC,AF,MAF \
  | bcftools view -i "MAF>=${MAF_MIN}" -Oz -o $TMP/merged.maf.vcf.gz
bcftools index -t $TMP/merged.maf.vcf.gz

# 4. Split back into reference and target
bcftools view -S $TMP/ref_samples.txt    --threads $THREADS -Oz -o $REF_OUT/03_MAF_filter/${CHR}.MAF.vcf.gz    $TMP/merged.maf.vcf.gz
bcftools view -S $TMP/target_samples.txt --threads $THREADS -Oz -o $TARGET_OUT/03_MAF_filter/${CHR}.MAF.vcf.gz $TMP/merged.maf.vcf.gz
bcftools index -t $REF_OUT/03_MAF_filter/${CHR}.MAF.vcf.gz
bcftools index -t $TARGET_OUT/03_MAF_filter/${CHR}.MAF.vcf.gz

# 5. SNP counts and consistency check
N_REF=$(count $TMP/ref.vcf.gz);            N_TGT=$(count $TMP/target.vcf.gz)
N_SHARED=$(count $TMP/isec/0000.vcf.gz);   N_MAF=$(count $TMP/merged.maf.vcf.gz)
N_REF_OUT=$(count $REF_OUT/03_MAF_filter/${CHR}.MAF.vcf.gz)
N_TGT_OUT=$(count $TARGET_OUT/03_MAF_filter/${CHR}.MAF.vcf.gz)

echo -e "chr\tref\ttarget\tshared\tafter_MAF\tref_out\ttarget_out" > $TARGET_OUT/03_MAF_filter/counts_chr${CHR}.tsv
echo -e "${CHR}\t${N_REF}\t${N_TGT}\t${N_SHARED}\t${N_MAF}\t${N_REF_OUT}\t${N_TGT_OUT}" >> $TARGET_OUT/03_MAF_filter/counts_chr${CHR}.tsv

if [ "$N_REF_OUT" != "$N_TGT_OUT" ]; then
    echo "ERROR: reference and target outputs differ in SNP count" >&2
    exit 1
fi

rm -rf $TMP