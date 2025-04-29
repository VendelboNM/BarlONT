rule bcftools_filter_sniffles2:
    input:
        "results/04_variant_calling/{sample}/long_variants.vcf",
    output:
        "results/04_variant_calling/{sample}/long_variants_filtered.vcf",
    log:
        "logs/04_variant_calling/bcftools_filter/{sample}.out",
    benchmark:
        "benchmarks/04_variant_calling/bcftools_filter/{sample}.tsv",
    params:
        filter=config["bcftools_filter_sniffles2"],
        extra="",
    threads: 5
    resources: 
        mem_mb=30000,
        runtime=lambda w, attempt: f"{6 * attempt} h",
    wrapper:
        "v5.9.0/bio/bcftools/filter"

rule bcftools_stats_gatk:
    input:
        "results/04_variant_calling/{sample}/short_variants_filtered.vcf",
    output:
        "results/04_variant_calling/{sample}/short_variants_filtered_stats.txt",
    log:
        "logs/04_variant_calling/bcftools_stats/short_variants/{sample}.out",
    benchmark:
        "benchmarks/04_variant_calling/bcftools_stats/{sample}.tsv",
    params:
        "",
    threads: 5
    resources: 
        mem_mb=30000,
        runtime=lambda w, attempt: f"{6 * attempt} h",
    wrapper:
        "v5.5.2/bio/bcftools/stats"

rule bcftools_stats_sniffles2:
    input:
        "results/04_variant_calling/{sample}/long_variants_filtered.vcf",
    output:
        "results/04_variant_calling/{sample}/long_variants_stats.txt",
    log:
        "logs/04_variant_calling/bcftools_stats/long_variants/{sample}.out",
    benchmark:
        "benchmarks/04_variant_calling/bcftools_stats/{sample}.tsv",
    params:
        "",
    threads: 5
    resources: 
        mem_mb=30000,
        runtime=lambda w, attempt: f"{6 * attempt} h",
    wrapper:
        "v5.5.2/bio/bcftools/stats"