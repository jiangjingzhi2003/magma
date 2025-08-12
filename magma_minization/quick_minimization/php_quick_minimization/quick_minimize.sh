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
./minimize.sh "$CORPUS_DIR" "$MINIMIZED_DIR" "$FUZZER_BIN"

