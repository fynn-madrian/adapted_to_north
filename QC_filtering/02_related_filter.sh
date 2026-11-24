#!/bin/bash
#SBATCH -A uppmax2026-1-301
#SBATCH -J relatedness_filtering
#SBATCH -t 12:00:00
#SBATCH -n 4
#SBATCH --mail-type=ALL
#SBATCH --output=./%x.%j.out

# RELATEDNESS FILTERING
# Filter out related individuals from the target dataset (third degree))
# double check:
# apd006 and apd016 have a first-degree relationship
# Kor002 and kor007, adn003 and adn004 are a second-degree relationship

# Seperarte the merged dataset into ref and target datasets and save