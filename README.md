# Adapted to the North

## 1. QC Filtering

### Step 00: Remove samples without metadata

Run 'sbatch QC_filtering/00_remove_meta.sh' from repo root. 
Removes individuals originally in the target data that lacks meta data information.

Input: 
- '/proj/northadapt/data/target/raw/merge_ibd.vcf.gz'

Output:
- '/proj/northadapt/data/target/filtered/00_meta_exclude/'

### Step 01: SNP filter 

Run 'QC_filtering/01_SNP_filter.sh' from repo root. 
Filters target and reference data on SNP quality. Both datasets are filtered on bialleic SNPs, INFO >= 0.8 and SMAX(FMT/GP) >= 0.99. Reference panel is additionally filtered on MASK_1000G=1. 

Input: 
- '/proj/northadapt/data/target/filtered/00_meta_exclude/target_filtered.vcf.gz'
- '/proj/northadapt/data/reference/raw/'

Output: 
- '/proj/northadapt/data/target/filtered/01_SNP_filter_with_gp'
- '/proj/northadapt/data/reference/filtered/01_SNP_filter_with_gp'

### Step 02: Target relatedness (KING)

Run `sbatch QC_filtering/03_related_filter.sh` from the repo root.

The shared folder is `/gorilla/proj/northadapt/data/target/filtered/03_related_filter/`. KING reads `king_markers/markers.vcf.gz` (198 targets, 92,862 phased markers) and writes `king_<jobid>.kin0` there.

- [Pairwise results](QC_filtering/king_results/qc_kinship.kin0)
- [42 proposed exclusions](QC_filtering/king_results/exclude_target_ids.txt)
- [Papers and supplementary materials](QC_filtering/king_results/README.md#papers-and-supplementary-materials)

### Step 03: MAF filtering of SNPs

Run 'sbatch /QC_filtering/03_MAF_filter.sh' from the repo root.  
Merges reference and target dataset for each chromosome in parallell, removes SNP sites not found in both and applies filter of MAF >= 0.01 on the remaining SNPs. This is done in 5 steps: 
1. Creates temporary folders per chromosome. 
2. Keeps only sites with identical positions (REF & ALT) in both files. Writes sites in same order in both files. Potentially swapped alleles are dropped here (no swapped alleles in raw data, checked previously). 
3. Merges the target and reference files and strips the INFO and FORMAT fields, leaving GT. Recomputes AN, AC, AF and MAF on merged data and filter on MAF >= 0.01. 
4. Seperates merged file into reference and target by sample name. The two files have identical SNPs. 
5. Writes a one line count table per chromosome and stops if outputs do not agree. 

Input: 
- Target data '/proj/northadapt/data/target/filtered/02_related_filter/target_filtered.vcf.gz'
- Reference data by chromosome from '/proj/northadapt/data/reference/filtered/01_SNP_filter_with_gp'

Output: 
- Tagret data by chromosome in '/proj/northadapt/data/target/filtered/03_MAF_filter/'
- Reference data by chromosome in '/proj/northadapt/data/reference/filtered/03_MAF_filter/'
- Count tables by chromosome '/proj/northadapt/data/target/filtered/03_MAF_filter/counts_chr*.tsv'

### Step 04: Transversion filter 

Run '/QC_filtering/04_transversion_filter.sh' from the repo root. 
Removes all transition SNPs from the target and reference data. Done as the last filter because originally a sanity check, however, will proceed with only the transversions in downstream analysis. 

Input: 
- Target data by chromosome in '/proj/northadapt/data/target/filtered/03_MAF_filter/'
- Reference data by chromosome in '/proj/northadapt/data/reference/filtered/03_MAF_filter'

Output: 
- Target data by chromosome in '/proj/northadapt/data/target/filtered/04_transversion_filter/'
- Reference data by chromosome in '/proj/northadapt/data/reference/filtered/04_transversion_filter'
