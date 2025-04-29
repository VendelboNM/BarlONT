rule chopper:
    input:
        "results/01_processing/porechop/{sample}_ont_porechop.fastq.gz"
    output:
        temp("results/01_processing/chopper/{sample}_ont_chopper.fastq.gz"),
    params:
        config = config["chopper"]
    log:
        "logs/01_processing/chopper/{sample}.out"
    benchmark:
        "benchmarks/01_processing/chopper/{sample}.tsv"
    conda:
        "../envs/01_chopper.yaml"
    threads: 5
    resources:
        mem_mb=5000,
        runtime=estimate_time_chopper
    shell:
        """
        (gunzip -c {input} | chopper {params.config} -t {threads} | gzip > {output}) 2> {log}

        """
