mkdir trial_{1..10}
for i in {1..10}; do
    mkdir -p "trial_$i/tiff_read_rgba_fuzzer" "trial_$i/tiffcp"
done

for i in {1..10}; do
    src="tiff_read_rgba_fuzzer_cmin/corpus/trial_$i"
    dst="trial_$i/tiff_read_rgba_fuzzer/"
    if [ -d "$src" ]; then
        mv "$src" "$dst"
    else
        echo "⚠️ Skipping $src (not found)"
    fi
done

for i in {1..10}; do
    src="tiff_tiffcp_cmin/corpus/trial_$i"
    dst="trial_$i/tiffcp/"
    if [ -d "$src" ]; then
        mv "$src" "$dst"
    else
        echo "⚠️ Skipping $src (not found)"
    fi
done
