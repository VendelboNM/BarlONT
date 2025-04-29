# filter_variants.awk
BEGIN { OFS="\t" }

# Header lines (those starting with '#')
/^#/ {
    print $0 > output_vcf    # Output header to output_vcf
    next
}

# Main logic
{
    ref_len = length($4)
    split($5, alts, ",")
    keep = 1
    for (i in alts) {
        alt_len = length(alts[i])
        if (abs(ref_len - alt_len) >= 50) {
            keep = 0
            break
        }
    }

    # If the variant should be kept, print to the filtered output VCF
    if (keep) {
        print $0 > output_vcf  # Print to filtered VCF
    } else {
        print $0 > output_removed  # Print to removed VCF
    }
}

# Absolute function for comparison
function abs(x) { return x < 0 ? -x : x }

