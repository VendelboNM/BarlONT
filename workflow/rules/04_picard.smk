rule picard_dict:
    input:
        "results/genomic_resources/morex/MorexV3.fasta",
    output:
        "results/genomic_resources/morex/MorexV3.dict",
    log:
        "logs/04_variant_calling/picard_dict/morexv3.out",
    benchmark:
        "benchmarks/04_variant_calling/picard_dict/morexv3.tsv"
    params:
        extra="",
    threads: 1
    resources:
        mem_mb=2000,
        runtime=lambda w, attempt: f"{1 * attempt} h",
    wrapper:
        "v3.0.3/bio/picard/createsequencedictionary"

rule picard_mark_duplicates:
    input:
        bams="results/04_variant_calling/{sample}/aln_bwa.bam",
    output:
        bam=temp("results/04_variant_calling/{sample}/dedup_bwa.bam"),
        metrics="results/04_variant_calling/{sample}/dedup_bwa_metrics.txt",
    log:
        "logs/04_variant_calling/picard_mark_duplicates/{sample}.out",
    benchmark:
        "benchmarks/04_variant_calling/picard_mark_duplicates/{sample}.tsv",
    params:
        extra="--REMOVE_DUPLICATES true",
    threads: 10
    resources: 
        mem_mb=30000,
        runtime=lambda w, attempt: f"{2 * attempt} d",
    wrapper:
        "v5.8.0/bio/picard/markduplicates"