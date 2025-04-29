rule sniffles2:
    input:
        bam="results/04_variant_calling/{sample}/aln_minimap2_sorted.bam",
        bai="results/04_variant_calling/{sample}/aln_minimap2_sorted.bam.bai",
        ref="results/genomic_resources/morex/MorexV3.fasta",
    output:
        "results/04_variant_calling/{sample}/long_variants.vcf",
    log:
        "logs/04_variant_calling/sniffles2/{sample}.out",
    benchmark:
        "benchmarks/04_variant_calling/sniffles2/{sample}.tsv",
    params:
        config = config["sniffles2"],
    conda:
        "../envs/04_sniffles2.yaml"
    threads: 15
    resources: 
        mem_mb=300000,
        runtime=lambda w, attempt: f"{2 * attempt} d",
    shell:
        """
            sniffles \
                --input {input.bam} \
                --vcf {output} \
                --threads {threads} \
                --reference {input.ref} \
                {params.config} \
                > {log} 2>&1
        """