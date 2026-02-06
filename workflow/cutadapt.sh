#!/bin/bash
set -e

# load config
source .env

# create output dir
mkdir -p "$TRIM_DIR"
mkdir -p "$FASTQC_DIR"

# file paths
TRIM_FILE="$TRIM_DIR/${SAMPLE_NAME}${SUFFIX_TRIM}"
NO_3AD_FILE="$TRIM_DIR/${SAMPLE_NAME}${SUFFIX_NO3}"
NO_5AD_FILE="$TRIM_DIR/${SAMPLE_NAME}${SUFFIX_NO5}"
TOO_SHORT_FILE="$TRIM_DIR/${SAMPLE_NAME}${SUFFIX_SHORT}"

echo "=============================="
echo "miRNA cutadapt trimming start"
echo "Sample: $SAMPLE_NAME"
echo "Input : $INPUT_FASTQ"
echo "Output: $TRIM_DIR"
echo "=============================="

# ---------------- 3' trimming ----------------
cutadapt \
  -a "$THREE_PRIME_AD_SEQ" \
  -e "$CUTADAPT_3P_ERROR" \
  $( [ "$MATCH_WILDCARDS" = true ] && echo "--match-read-wildcards" ) \
  --untrimmed-output="$NO_3AD_FILE" \
  "$INPUT_FASTQ" \
| \
# ---------------- 5' trimming ----------------
cutadapt \
  -e "$CUTADAPT_5P_ERROR" \
  $( [ "$MATCH_WILDCARDS" = true ] && echo "--match-read-wildcards" ) \
  $( [ "$NO_INDELS" = true ] && echo "--no-indels" ) \
  -m "$CUTADAPT_MIN_LENGTH" \
  -O "$CUTADAPT_OVERLAP" \
  -n "$CUTADAPT_TIMES" \
  -g "$FIVE_PRIME_AD1_SEQ" \
  -g "$FIVE_PRIME_AD2_SEQ" \
  -g "$FIVE_PRIME_AD3_SEQ" \
  -g "$FIVE_PRIME_AD4_SEQ" \
  --untrimmed-output="$NO_5AD_FILE" \
  --too-short-output="$TOO_SHORT_FILE" \
  - \
  > "$TRIM_FILE"

# ---------------- QC ----------------
fastqc \
  -t "$FASTQC_THREADS" \
  "$INPUT_FASTQ" \
  "$TRIM_FILE" \
  "$NO_3AD_FILE" \
  "$NO_5AD_FILE" \
  "$TOO_SHORT_FILE" \
  -o "$FASTQC_DIR"

echo "=============================="
echo "QC finished"
echo "FastQC dir : $FASTQC_DIR"
echo "=============================="