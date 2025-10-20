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
for dir in "$CORPUS_DIR"/*/; do
    subdir_name=$(basename "$dir")
    echo "Minimizing corpus for $subdir_name..."
    mkdir -p "$MINIMIZED_DIR/$dir"

    ./minimize.sh "$dir" "$MINIMIZED_DIR/$dir" "$FUZZER_BIN"
done
