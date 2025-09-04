#!/bin/bash

##
# Pre-requirements:
# - env FUZZER: path to fuzzer work dir
# - env TARGET: path to target work dir
# - env OUT: path to directory where artifacts are stored
# - env SHARED: path to directory shared with host (to store results)
# - env PROGRAM: name of program to run (should be found in $OUT)
# - env ARGS: extra arguments to pass to the program
# - env FUZZARGS: extra arguments to pass to the fuzzer
# - env POLL: time (in seconds) to sleep between polls
# - env TIMEOUT: time to run the campaign
# - env MAGMA: path to Magma support files
# + env LOGSIZE: size (in bytes) of log file to generate (default: 1 MiB)
##


export AFL_SKIP_CPUFREQ=1
export AFL_NO_AFFINITY=1
export AFL_NO_UI=1
export AFL_MAP_SIZE=256000
export AFL_DRIVER_DONT_DEFER=1

if nm "$OUT/afl/$PROGRAM" | grep -E '^[0-9a-f]+\s+[Ww]\s+main$'; then
    ARGS="-"
fi

cp -r "$TARGET/$CORPUS/$PROGRAM" "./initial_corpus"

echo "Running afl-cmin..."
CMIN_OUT_DIR="./cmin-output"
mkdir -p "./cmin-output"

"$FUZZER/repo/afl-cmin" \
  -i "./initial_corpus" \
  -o "$CMIN_OUT_DIR" \
  -t 1000 -- \
  "$OUT/afl/$PROGRAM" $ARGS 2>&1

if [ -z "$(find ./cmin-output -type f -maxdepth 1 2>/dev/null)" ]; then
  echo "afl-cmin produced no files; aborting."
  exit 1
fi

# Replace the old corpus with a copy of the minimized one
rm -rf "$TARGET/$CORPUS/$PROGRAM"
cp -r ./cmin-output "$TARGET/$CORPUS/$PROGRAM"

# Cleanup the temporary initial corpus
rm -rf "./initial_corpus"
rm -rf "./cmin-output"