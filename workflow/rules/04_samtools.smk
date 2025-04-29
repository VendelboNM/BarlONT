rule samtools_faidx:
    input:
        "results/genomic_resources/morex/MorexV3.fasta",
    output:
        "results/genomic_resources/morex/MorexV3.fasta.fai",
    log:
        "logs/04_variant_calling/samtools_faidx/morexv3.out",
    benchmark:
        "benchmarks/04_variant_calling/samtools_faidx/morexv3.tsv",
    params:
        extra="",
    threads: 1
    resources: 
        mem_mb=1000,
        runtime=lambda w, attempt: f"{1 * attempt} h",
    wrapper:
        "v5.8.1/bio/samtools/faidx"

rule samtools_index_bwa:
    input:
        "results/04_variant_calling/{sample}/dedup_bwa.bam",
    output:
        temp("results/04_variant_calling/{sample}/dedup_bwa.bam.csi"),
    log:
        "logs/04_variant_calling/samtools_index_bwa/{sample}.out",
    benchmark:
        "benchmarks/04_variant_calling/samtools_index_bwa/{sample}.tsv",
    params:
        extra="-m 14",
    threads: 1
    resources: 
        mem_mb=5000,
        runtime=lambda w, attempt: f"{1 * attempt} h",
    wrapper:
        "v5.8.1/bio/samtools/index"

rule samtools_index_minimap2:
    input:
        "results/04_variant_calling/{sample}/aln_minimap2_sorted.bam",
    output:
        temp("results/04_variant_calling/{sample}/aln_minimap2_sorted.bam.bai"),
    log:
        "logs/04_variant_calling/samtools_index_minimap2/{sample}.out",
    benchmark:
        "benchmarks/04_variant_calling/samtools_index_minimap2/{sample}.tsv",
    params:
        extra="-m 14",
    threads: 1
    resources: 
        mem_mb=5000,
        runtime=lambda w, attempt: f"{1 * attempt} h",
    wrapper:
        "v5.8.1/bio/samtools/index"
    
rule samtools_view:
    input:
        "results/04_variant_calling/{sample}/aln_minimap2.sam",
    output:
        temp("results/04_variant_calling/{sample}/aln_minimap2.bam"),
    log:
        "logs/04_variant_calling/samtools_view/{sample}.out",
    benchmark:
        "benchmarks/04_variant_calling/samtools_view/{sample}.tsv",
    params:
        extra="",  # optional params string
        region="",  # optional region string
    threads: 5
    resources: 
        mem_mb=5000,
        runtime=lambda w, attempt: f"{6 * attempt} h",
    wrapper:
        "v5.8.2/bio/samtools/view"

rule samtools_sort:
    input:
        bam="results/04_variant_calling/{sample}/aln_minimap2.bam",
    output:
        temp("results/04_variant_calling/{sample}/aln_minimap2_sorted.bam"),
    log:
        "logs/04_variant_calling/samtools_sort/{sample}.out",
    benchmark:
        "benchmarks/04_variant_calling/samtools_sort/{sample}.tsv",
    params:
        extra="-m 4G",
    threads: 10
    resources: 
        mem_mb=50000,
        runtime=lambda w, attempt: f"{1 * attempt} d",
    wrapper:
        "v5.8.2/bio/samtools/sort"