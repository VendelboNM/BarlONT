rule gatk_haplotype_caller:
    input:
        bam="results/04_variant_calling/{sample}/dedup_bwa.bam",
        csi="results/04_variant_calling/{sample}/dedup_bwa.bam.csi",
        ref="results/genomic_resources/morex/MorexV3.fasta",
        ref_dict="results/genomic_resources/morex/MorexV3.dict",
    output:
        vcf="results/04_variant_calling/{sample}/short_variants.vcf",
    log:
        "logs/04_variant_calling/gatk_haplotype_caller/{sample}.out",
    benchmark:
        "benchmarks/04_variant_calling/gatk_haplotype_caller/{sample}.tsv",
    params:
        extra="",
        java_opts="",
    threads: 30
    resources:
        mem_mb=300000,
        runtime=lambda w, attempt: f"{4 * attempt} d",
    wrapper:
        "v5.8.0/bio/gatk/haplotypecaller"

rule gatk_variant_filtration:
    input:
        vcf="results/04_variant_calling/{sample}/short_variants.vcf",
        ref="results/genomic_resources/morex/MorexV3.fasta",
    output:
        vcf="results/04_variant_calling/{sample}/short_variants_filtered.vcf",
    log:
        "logs/04_variant_calling/gatk_variant_filtration/{sample}.out",
    benchmark:
        "benchmarks/04_variant_calling/gatk_variant_filtration/{sample}.tsv",
    params:
        filters={"myfilter": config["gatk_variant_filtration"]},
        extra="",
        java_opts="-XX:ParallelGCThreads=5",
    resources:
        mem_mb=5000,
        runtime=lambda w, attempt: f"{1 * attempt} h",
    wrapper:
        "v5.8.0/bio/gatk/variantfiltration"

rule gatk_select:
    input:
        vcf="results/04_variant_calling/{sample}/short_variants_filtered.vcf",
        ref="results/genomic_resources/morex/MorexV3.fasta",
    output:
        vcf="results/04_variant_calling/{sample}/short_variants_filtered1.vcf",
    log:
        "logs/04_variant_calling/gatk_select/{sample}.out",
    benchmark:
        "benchmarks/04_variant_calling/gatk_select/{sample}.tsv",
    params:
        extra="--exclude-filtered",
        java_opts="-XX:ParallelGCThreads=5", 
    resources:
        mem_mb=5000,
    wrapper:
        "v1.5.0/bio/gatk/selectvariants"