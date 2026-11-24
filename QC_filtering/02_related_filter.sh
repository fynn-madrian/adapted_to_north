#!/bin/bash
#SBATCH -A uppmax2026-1-301
#SBATCH -J target_king
#SBATCH -t 00:10:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=5G

module load PLINK/2.0.0-a.6.20-gfbf-2024a
base=/gorilla/proj/northadapt/data/target/filtered
out=$base/02_related_filter
vcf=$out/king_markers/markers.vcf.gz

plink2 --vcf "$vcf" --double-id \
    --make-king-table --threads "$SLURM_CPUS_PER_TASK" --out "$out/king_$SLURM_JOB_ID"
