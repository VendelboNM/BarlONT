rule fastp:
    input:
        pe_1 = os.path.join(config["data"],"illu", "{sample}_1_illu_raw.fastq.gz"),
        pe_2 = os.path.join(config["data"],"illu", "{sample}_2_illu_raw.fastq.gz"),
    output:
        illu_1 = "results/01_processing/fastp/{sample}_1_illu_processed.fastq.gz",
        illu_2 = "results/01_processing/fastp/{sample}_2_illu_processed.fastq.gz",
        html = "results/01_processing/fastp/{sample}_illu_fastp.html",
        json = "results/01_processing/fastp/{sample}_illu_fastp.json",
    params:
        config = config["fastp"]
    benchmark:
        "benchmarks/01_processing/fastp/{sample}.tsv"
    log:
        "logs/01_processing/fastp/{sample}.out",
    conda:
         "../envs/01_fastp.yaml"
    threads: 8
    resources: 
        mem_mb=8000,
        runtime=estimate_time_fastp
    shell:
        """
        fastp \
            --thread {threads} \
            --in1 {input.pe_1} \
            --in2 {input.pe_2} \
            {params.config} \
            --out1 {output.illu_1} \
            --out2 {output.illu_2} \
            --json {output.json} \
            --html {output.html} \
            --report_title "$(basename {output.html} .html)" \
            > {log} 2>&1
        """
