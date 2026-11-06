# Project 1: Quick Bed Sort

Combines all BED files of one sample, keeps only the chromosomes listed in a
selection file, and sorts the lines in the **same chromosome order as the selection file**
(then by start and end position).

## Files

- `sort_bed.sh`: main script (run this)
- `filter_chrom.py`: keeps the selected chromosomes and adds their order number for sorting

## Input

- BED files of one sample, e.g. `shuf.a.bed.gz` and `shuf.b.bed.gz` (sample `X`)
- A selection file with one chromosome per line, in the order wanted,
  e.g. `standard_selection.tsv` (chr1 to chr22, chrX, chrY)

## How to run

```bash
chmod +x sort_bed.sh
./sort_bed.sh SAMPLE SELECTION_FILE BED_FILE1 BED_FILE2 ...
```

Example:

```bash
./sort_bed.sh X standard_selection.tsv shuf.a.bed.gz shuf.b.bed.gz
```

## Output

The output goes into the folder `sorted_bed_file_per_sample/` and its name contains
the sample and the selection:

```
sorted_bed_file_per_sample/X.standard.sorted.bed.gz
```

A different selection file gives a different output, e.g. `custom_selection.tsv`
gives `X.custom.sorted.bed.gz`.

## How it works

1. `gzip -cd` unzips all BED files of the sample into one stream
2. `filter_chrom.py` keeps lines whose chromosome is in the selection file and adds its position in that file (chr1 = 0, chr2 = 1, ...) as an extra first column
3. `sort` sorts by that number, then by start, then by end
4. `cut -f2-` removes the extra column
5. `gzip` compresses the result

## Check the result

```bash
gzip -cd sorted_bed_file_per_sample/X.standard.sorted.bed.gz | head
gzip -cd sorted_bed_file_per_sample/X.standard.sorted.bed.gz | cut -f1 | uniq
```

The second command lists the chromosomes in the order they appear and should match the selection file.

## Requirements

Bash, Python 3, gzip, sort, cut (all built into macOS and Linux).
