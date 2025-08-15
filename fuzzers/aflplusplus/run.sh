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
##

if nm "$OUT/afl/$PROGRAM" | grep -E '^[0-9a-f]+\s+[Ww]\s+main$'; then
    ARGS="-"
fi

mkdir -p "$SHARED/findings"

flag_cmplog=(-m none -c "$OUT/cmplog/$PROGRAM")

export AFL_SKIP_CPUFREQ=1
export AFL_NO_AFFINITY=1
export AFL_NO_UI=1
export AFL_MAP_SIZE=256000
export AFL_DRIVER_DONT_DEFER=1

MINIMIZED_DIR="$SHARED/min_corpus"
TMP_INPUT_DIR="$SHARED/tmp_origin_corpus"

mkdir -p "$MINIMIZED_DIR"
mkdir -p "$TMP_INPUT_DIR"

# Copy input corpus to a temp dir on the same filesystem
cp -r "$TARGET/corpus/$PROGRAM"/* "$TMP_INPUT_DIR/"
AFL_DEBUG=1 "$FUZZER/repo/afl-cmin" -i "$TMP_INPUT_DIR" -o "$MINIMIZED_DIR" -t 1000 -- "$OUT/afl/$PROGRAM" @@

echo "$FUZZER/repo/afl-fuzz"

"$FUZZER/repo/afl-fuzz" -i "$TARGET/$CORPUS/$PROGRAM" -o "$SHARED/findings" \
    "${flag_cmplog[@]}" -d \
    $FUZZARGS -- "$OUT/afl/$PROGRAM" $ARGS 2>&1
