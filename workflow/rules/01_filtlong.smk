rule filtlong:
    input:
        illu_1 = "results/01_processing/fastp/{sample}_1_illu_processed.fastq.gz",
        illu_2 = "results/01_processing/fastp/{sample}_2_illu_processed.fastq.gz",
        chopper = "results/01_processing/chopper/{sample}_ont_chopper.fastq.gz"
    output:
        "results/01_processing/filtlong/{sample}_ont_processed.fastq.gz",
    params:
        config = config["filtlong"]
    log:
        "logs/01_processing/filtlong/{sample}.out",
    benchmark:
        "benchmarks/01_processing/filtlong/{sample}.tsv"
    conda:
        "../envs/01_filtlong.yaml"
    threads: 1
    resources:
        mem_mb=100000,
        runtime=estimate_time_filtlong
    shell:
        """
        (filtlong -1 {input.illu_1} -2 {input.illu_2} {params.config} {input.chopper} | gzip > {output}) 2> {log}

        """
