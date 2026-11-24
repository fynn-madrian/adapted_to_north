# Adapted to the North

## Step 03: Target relatedness (KING)

On Pelle, run `sbatch QC_filtering/03_related_filter.sh` from the repo root.

The shared folder is `/gorilla/proj/northadapt/data/target/filtered/03_related_filter/`. KING reads `king_markers/markers.vcf.gz` (198 targets, 92,862 phased markers) and writes `king_<jobid>.kin0` there.

- [Pairwise results](QC_filtering/king_results/qc_kinship.kin0)
- [42 proposed exclusions](QC_filtering/king_results/exclude_target_ids.txt)
- [Papers and supplementary materials](QC_filtering/king_results/README.md#papers-and-supplementary-materials)
