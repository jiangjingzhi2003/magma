#!/bin/bash
set -e

echo "core" | tee /proc/sys/kernel/core_pattern

# Set a permissive umask so that new files are created with broad permissions.
umask 000

# Check that the fuzzer binary has been set
if [[ -z "$FUZZER_BIN" ]]; then
    echo "Error: make sure FUZZER_BIN is set in the Dockerfile"
    exit 1
fi


# Generate minimized corpus
# ./minimize.sh "$CORPUS_DIR" "$MINIMIZED_DIR" "$FUZZER_BIN"

# Loop through each subdirectory in CORPUS_DIR
for dir in "$CORPUS_DIR"/*/"$FUZZ_TARGET"; do
  rel_path="${dir#"$CORPUS_DIR"/}"
  out_dir="$MINIMIZED_DIR/$rel_path"

  echo "Minimizing corpus for: $rel_path"
  mkdir -p "$out_dir"

  ./minimize.sh "$dir" "$out_dir" "$FUZZER_BIN"
done

