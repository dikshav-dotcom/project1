import sys

# The selection file is given as the first argument, e.g. standard_selection.tsv
selection_file = sys.argv[1]

# Read the chromosome order: chr1 -> 0, chr2 -> 1, ...
order = {}
for line in open(selection_file):
    chrom = line.strip()
    if chrom != "":
        order[chrom] = len(order)

# Read BED lines from standard input
for line in sys.stdin:
    cols = line.split("\t")
    chrom = cols[0]

    # Keep the line only if its chromosome is in the selection file
    if chrom in order:
        # Put the order number in front so 'sort' can use it
        sys.stdout.write(str(order[chrom]) + "\t" + line)
