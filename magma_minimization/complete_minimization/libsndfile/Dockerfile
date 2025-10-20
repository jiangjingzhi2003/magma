# 1) Builder stage: compile fuzz target
# Image source from https://aflplus.plus/docs/install/. Will remain up to date with AFL++.
FROM aflplusplus/aflplusplus:latest AS builder

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Force CMake / Make to use AFL’s compilers
ENV CC=afl-clang-fast
ENV CXX=afl-clang-fast++
ENV CFLAGS="-O2 -g"
ENV CXXFLAGS="-O2 -g"
ENV LIB_FUZZING_ENGINE="-fsanitize=fuzzer"
ENV LIB="/usr/local/lib/afl/libAFLDriver.a"
ENV LDFLAGS="-lpthread"

ENV SRC=/src
ENV OUT=/out
ENV WORK=/work
ENV CORPUS_DIR=/seeds
RUN mkdir -p $SRC $OUT $WORK

# Create input/output directories
RUN mkdir -p /corpus /corpus_min /afl-output /out

# ----- TODO: FILL THIS SECTION OUT -----
RUN apt-get update && apt-get install -y patch
COPY preinstall.sh /preinstall.sh
COPY fetch.sh /fetch.sh
COPY build.sh /build.sh
COPY apply_patches.sh /apply_patches.sh
COPY patches /patches/
RUN chmod +x /preinstall.sh /fetch.sh /build.sh /apply_patches.sh
# PART 1:
# Compile the fuzz target in /out. An example workflow is:
#   1) Install the required dependencies
RUN /preinstall.sh
# #   2) Clone the github repository
RUN /fetch.sh && /apply_patches.sh
# #   3) Compile the fuzz target using afl-clang-fast or afl-clang-fast++ and setting
# #      the -o flag to /out/fuzz_target.
RUN /build.sh
# # PART 2:
# # After compiling the fuzz target, assign it to the environment variable FUZZER_BIN
# # Example:
ENV FUZZER_BIN=/out/sndfile_fuzzer

# # -----      END OF SECTION       -----

# # Copy the entrypoint script into the image and grant executable permissions
COPY entrypoint.sh /entrypoint.sh
COPY minimize.sh /minimize.sh
COPY quick_minimize.sh /quick_minimize.sh
RUN chmod +x /entrypoint.sh /minimize.sh /quick_minimize.sh

# # Create a non-root user "fuzz" for running fuzzing tasks
RUN useradd -ms /bin/bash fuzz \
  && chown -R fuzz:fuzz /corpus /corpus_min /afl-output /out \
  && chmod -R u+rwX /corpus /corpus_min /afl-output /out

# # Switch to non-root user's home directory
 USER root
 WORKDIR /
