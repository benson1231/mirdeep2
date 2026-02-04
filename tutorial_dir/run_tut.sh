#!/bin/bash
set -e

# 建立輸出資料夾
mkdir -p index
mkdir -p mapping
mkdir -p bowtie_logs
mkdir -p results/logs

############################
# 1. Build bowtie index
############################
bowtie-build refs/cel_cluster.fa index/cel_cluster
ec=$?
if [ $ec != 0 ]; then
  echo "An error occurred in bowtie-build, exit code $ec"
  exit $ec
fi

############################
# 2. mapper.pl
############################
mapper.pl data/new_reads.fa \
  -c -j \
  -k TCGTATGCCGTCTTCTGCTTGT \
  -l 18 -m \
  -p index/cel_cluster \
  -s mapping/reads_collapsed.fa \
  -t mapping/reads_collapsed_vs_genome.arf \
  -v -n

ec=$?
if [ $ec != 0 ]; then
  echo "An error occurred in mapper.pl, exit code $ec"
  exit $ec
fi

mv bowtie.log bowtie_logs/bowtie.log
echo "mapper.pl finished successfully."

############################
# 3. miRDeep2.pl
#    在 results/ 目錄中執行
############################
cd results

miRDeep2.pl \
  ../mapping/reads_collapsed.fa \
  ../refs/cel_cluster.fa \
  ../mapping/reads_collapsed_vs_genome.arf \
  ../refs/mature_ref_this_species.fa \
  ../refs/mature_ref_other_species.fa \
  ../refs/precursors_ref_this_species.fa \
  -t C.elegans \
  -P \
  2> logs/report.log

ec=$?
if [ $ec != 0 ]; then
  echo "An error occurred in miRDeep2.pl, exit code $ec"
  exit $ec
fi

echo "miRDeep2 pipeline finished successfully."
