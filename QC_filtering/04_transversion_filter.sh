#!/bin/bash
#SBATCH -A uppmax2026-1-301
#SBATCH -J MAF_filtering
#SBATCH -t 12:00:00
#SBATCH -n 4
#SBATCH --mail-type=ALL
#SBATCH --output=./%x.%j.out

# Transversion filter for sanity check, save datasetss

