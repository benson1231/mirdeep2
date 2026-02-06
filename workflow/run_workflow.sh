#!/usr/bin/env bash
set -e
source .env

################################
# Create directories
################################
mkdir -p "$INDEX_DIR" "$MAPPING_DIR" "$BOWTIE_LOG_DIR" "$LOG_DIR" "$TRIM_DIR"

################################
# Step 1: Build Bowtie index
################################
echo "[Step 1] Building Bowtie index..."

if [ ! -f "${BOWTIE_INDEX_PREFIX}.1.ebwt" ]; then
  bowtie-build "$GENOME_FASTA" "$BOWTIE_INDEX_PREFIX"
else
  echo "Bowtie index already exists. Skipping build."
fi

################################
# Step 2: mapper.pl
################################
echo "[Step 2] Running mapper.pl..."

mapper.pl "$MAPPER_INPUT" \
  -j -e -h \
  -l "$MAPPER_MIN_LEN" -m \
  -p "$BOWTIE_INDEX_PREFIX" \
  -s "$MAPPER_COLLAPSED" \
  -t "$MAPPER_ARF" \
  -v

mv bowtie.log "$BOWTIE_LOG_DIR/bowtie.log" || true

################################
# Step 3: miRDeep2
################################
echo "[Step 3] Running miRDeep2..."

GENOME_CLEAN_FASTA="${REF_DIR}/human_hg38_clean.fa"

if [ ! -f "$GENOME_CLEAN_FASTA" ]; then
  echo "Creating cleaned genome FASTA..."
  sed 's/ .*//' "$GENOME_FASTA" > "$GENOME_CLEAN_FASTA"
else
  echo "Cleaned genome FASTA already exists. Skipping."
fi

cd "$RESULTS_DIR"

miRDeep2.pl \
  "$MAPPER_COLLAPSED" \
  "${REF_DIR}/human_hg38_clean.fa" \
  "$MAPPER_ARF" \
  "$MATURE_THIS" \
  "$MATURE_OTHER" \
  "$PRECURSOR_THIS" \
  -t "$SPECIES_TAG" \
  -P \
  -c \
  2> "$LOG_DIR/report.log"

cd ..

echo "Pipeline finished successfully."
