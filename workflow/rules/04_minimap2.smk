rule minimap2:
    input:
        target="results/genomic_resources/morex/MorexV3.fasta",  # can be either genome index or genome fasta
        query="results/01_processing/filtlong/{sample}_ont_processed.fastq.gz",
    output:
        temp("results/04_variant_calling/{sample}/aln_minimap2.sam"),
    log:
        "logs/04_variant_calling/minimap2/{sample}.out",
    benchmark:
        "benchmarks/04_variant_calling/minimap2/{sample}.tsv",
    params:
        extra="-ax map-ont --MD",  # optional
        sorting="none",  # optional: Enable sorting. Possible values: 'none', 'queryname' or 'coordinate'
        sort_extra="",  # optional: extra arguments for samtools/picard
    threads:30
    resources: 
        mem_mb=50000,
        runtime=lambda w, attempt: f"{3 * attempt} d",
    wrapper:
        "v5.8.2/bio/minimap2/aligner"