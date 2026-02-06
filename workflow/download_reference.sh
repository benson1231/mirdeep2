#!/bin/bash

set -e

mkdir -p refs

############################
# 1. 下載 miRBase
############################

wget -P refs https://mirbase.org/download/mature.fa
wget -P refs https://mirbase.org/download/hairpin.fa

############################
# 2. 抽 human miRNA
############################

extract_miRNAs.pl refs/mature.fa hsa > refs/mature_ref_this_species.fa
extract_miRNAs.pl refs/hairpin.fa hsa > refs/precursors_ref_this_species.fa

############################
# 3. 抽其他近緣物種 miRNA（建議）
############################

extract_miRNAs.pl refs/mature.fa mmu,rno > refs/mature_ref_other_species.fa

############################
# 4. 下載 human genome (hg38)
############################

wget -P refs https://ftp.ensembl.org/pub/release-113/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
gzip -d -c refs/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz > refs/human_hg38.fa


