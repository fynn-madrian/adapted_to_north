#!/bin/bash
#SBATCH -A uppmax2026-1-301
#SBATCH -J download_reference
#SBATCH -t 12:00:00
#SBATCH -n 2

download_path=/gorilla/proj/northadapt/reference/
urls=reference_urls.txt

wget -c -P "$download_path" -i "$urls"
