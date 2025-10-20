#!/bin/bash
# trap 'echo "Received termination signal. Shutting down..."; exit 0' SIGTERM SIGINT
set -e

echo "core" | tee /proc/sys/kernel/core_pattern

# Set a permissive umask so that new files are created with broad permissions.
umask 000

# Check that the fuzzer binary has been set
if [[ -z "$FUZZER_BIN" ]]; then
    echo "Error: make sure FUZZER_BIN is set in the Dockerfile"
    exit 1
fi
./build.sh
# Generate minimized corpus
if [[ "$#" -eq 1 && "$1" -eq "minimize" ]]; then
    # /minimize.sh "$CORPUS_DIR" "$MINIMIZED_DIR" "$FUZZER_BIN"
    # FUZZ_CORPUS="$MINIMIZED_DIR"
    /quick_minimize.sh
else
    FUZZ_CORPUS="$CORPUS_DIR"
fi

if [[ $? -eq 1 ]]; then
    echo "Minimization failed!"
    exit 1
fi
