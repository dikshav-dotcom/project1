#!/bin/bash
# Usage: ./sort_bed.sh SAMPLE SELECTION_FILE BED_FILE1 BED_FILE2 ...
# Example: ./sort_bed.sh X standard_selection.tsv shuf.a.bed.gz shuf.b.bed.gz

if [ $# -lt 3 ]; then
    echo "Usage: ./sort_bed.sh SAMPLE SELECTION_FILE BED_FILE1 [BED_FILE2 ...]"
    exit 1
fi

sample=$1                  # e.g. X
selection_file=$2          # e.g. standard_selection.tsv
shift 2                    # the rest of the arguments are the BED files

# Selection name from the file name: standard_selection.tsv -> standard
selection=$(basename "$selection_file" .tsv)
selection=${selection%_selection}

output_dir="sorted_bed_file_per_sample"
output="$output_dir/${sample}.${selection}.sorted.bed.gz"
mkdir -p "$output_dir"

# 1. gzip -cd           : unzip all BED files of this sample into one stream
# 2. filter_chrom.py    : keep selected chromosomes, add order number in column 1
# 3. sort               : by order number, then start, then end (all numeric)
# 4. cut -f2-           : remove the order number again
# 5. gzip               : compress the result
gzip -cd "$@" |
    python3 filter_chrom.py "$selection_file" |
    LC_ALL=C sort -t $'\t' -k1,1n -k3,3n -k4,4n |
    cut -f2- |
    gzip > "$output"

echo "Done: $output"
echo "Lines written: $(gzip -cd "$output" | wc -l)"
