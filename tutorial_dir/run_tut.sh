#!/bin/bash
set -e

# 建立輸出資料夾
mkdir -p results

############################
# 1. Build bowtie index
############################
bowtie-build cel_cluster.fa results/cel_cluster
ec=$?
if [ $ec != 0 ]; then
  echo "An error occurred in bowtie-build, exit code $ec"
  exit $ec
fi

############################
# 2. mapper.pl
############################
mapper.pl reads.fa \
  -c -j \
  -k TCGTATGCCGTCTTCTGCTTGT \
  -l 18 -m \
  -p results/cel_cluster \
  -s results/reads_collapsed.fa \
  -t results/reads_collapsed_vs_genome.arf \
  -v -n

ec=$?
if [ $ec != 0 ]; then
  echo "An error occurred in mapper.pl, exit code $ec"
  exit $ec
fi

############################
# 3. miRDeep2.pl
#    在 results/ 目錄中執行
############################
cd results

miRDeep2.pl \
  reads_collapsed.fa \
  ../cel_cluster.fa \
  reads_collapsed_vs_genome.arf \
  ../mature_ref_this_species.fa \
  ../mature_ref_other_species.fa \
  ../precursors_ref_this_species.fa \
  -t C.elegans \
  2> report.log

ec=$?
if [ $ec != 0 ]; then
  echo "An error occurred in miRDeep2.pl, exit code $ec"
  exit $ec
fi

echo "miRDeep2 pipeline finished successfully."
