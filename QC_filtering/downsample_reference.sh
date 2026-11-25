#!/bin/bash
#SBATCH -A uppmax2026-1-301
#SBATCH -J downsample
#SBATCH -t 1:00:00
#SBATCH -n 2



#Individual ID,
target=/gorilla/proj/northadapt/41586_2023_6865_MOESM6_ESM.csv

awk -F',' '
    NR == 1 {
        for (i = 1; i <= NF; i++)
            if ($i == "Group label") col = i
        next
    }
    { count[$col]++ }
    END { for (g in count) print g "\t" count[g] }
' $target | sort -k2,2nr > group_counts.tsv


#get counts for groups
#set proportion
#set counts
#random downsample