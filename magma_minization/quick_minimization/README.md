# Quick Minimization

## Step 1: goes into the fuzzing target directory
```bash
   cd <fuzzing target program>
   ```
   then copy the corpus you want to minimize into corpus/ directory
## Step 2: build docker image
directory name is <program_name>_quick_minimization 
run 
```bash
docker build -t fuzz-<program_name>-quickmin .
```

## Step 3: change docker-compose.yaml to point to fuzzing harness
Edit docker-compose.yaml's envrionment variable
FUZZER_BIN: /out/libpng_read_fuzzer

```   environment:
      CORPUS_DIR: /corpus
      OUTPUT_DIR: /afl-output
      OUT: /out
      MINIMIZED_DIR: /corpus_min
      FUZZER_ID: master
      FUZZER_BIN: /out/libpng_read_fuzzer # change this 
```

## Step 4: run minimization
```bash
docker compose up -p <any name you want> up afl-<program_name>-quickmin
```