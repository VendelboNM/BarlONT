rule bwa_mem2_index:
    input:
        "results/genomic_resources/morex/MorexV3.fasta",
    output:
        "results/genomic_resources/morex/MorexV3.fasta.0123",
        "results/genomic_resources/morex/MorexV3.fasta.amb",
        "results/genomic_resources/morex/MorexV3.fasta.ann",
        "results/genomic_resources/morex/MorexV3.fasta.bwt.2bit.64",
        "results/genomic_resources/morex/MorexV3.fasta.pac",
    log:
        "logs/04_variant_calling/bwa_mem2_index/morexv3.out",
    benchmark:
        "benchmarks/04_variant_calling/bwa_mem2_index/morexv3.tsv",
    threads: 1
    resources: 
        mem_mb=5000,
        runtime=lambda w, attempt: f"{2 * attempt} h",
    wrapper:
        "v3.0.3/bio/bwa-mem2/index"

rule bwa_mem2:
    input:
        reads=["results/01_processing/fastp/{sample}_1_illu_processed.fastq.gz", "results/01_processing/fastp/{sample}_2_illu_processed.fastq.gz"],
        idx=multiext("results/genomic_resources/morex/MorexV3.fasta", ".amb", ".ann", ".bwt.2bit.64", ".pac", ".0123"),
        sam_index = "results/genomic_resources/morex/MorexV3.fasta.fai",
    output:
        temp("results/04_variant_calling/{sample}/aln_bwa.bam"),
    log:
        "logs/04_variant_calling/bwa_mem2/{sample}.out",
    benchmark:
        "benchmarks/04_variant_calling/bwa_mem2/{sample}.tsv",
    params:
        extra=r"-R '@RG\tID:{sample}\tSM:{sample}\tLB:lib1\tPL:illumina_pe150\tPU:{sample}'",
        sort="samtools",  # Can be 'none', 'samtools', or 'picard'.
        sort_order="coordinate",  # Can be 'coordinate' (default) or 'queryname'.
        sort_extra="",  # Extra args for samtools/picard sorts.
    threads: 15
    resources: 
        mem_mb=100000,
        runtime=lambda w, attempt: f"{2 * attempt} d",
    wrapper:
        "v5.5.2/bio/bwa-mem2/mem"