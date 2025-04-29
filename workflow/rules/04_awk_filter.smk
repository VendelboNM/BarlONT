rule awk_filter:
    input:
        "results/04_variant_calling/{sample}/short_variants_filtered1.vcf",
    output:
        vcf="results/04_variant_calling/{sample}/short_variants_filtered2.vcf",
        removed="results/04_variant_calling/{sample}/short_variants_removed.vcf",
    log:
        "logs/04_variant_calling/awk_filter/{sample}.out",
    benchmark:
        "benchmarks/04_variant_calling/awk_filter/{sample}.tsv",
    params:
        script="../barlont/workflow/scripts/04_filter.awk",
    conda:
        "../envs/04_awk.yaml"
    threads: 1
    resources: 
        mem_mb=2000,
        runtime=lambda w, attempt: f"{1 * attempt} h",
    shell:
        """
        awk -v output_vcf={output.vcf} -v output_removed={output.removed} -f {params.script} {input} > {log} 2>&1
        """
    