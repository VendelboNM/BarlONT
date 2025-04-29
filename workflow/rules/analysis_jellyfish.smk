rule jellyfish_count:
    input:
        illu_1 = os.path.join(config["data"],"illu", "{sample}_1_illu_raw.fastq.gz"),
        illu_2 = os.path.join(config["data"],"illu", "{sample}_2_illu_raw.fastq.gz"),
    output:
        "results/analysis/jellyfish/{sample}/{sample}_illu_count.jf"
    params:
        config = config["jellyfish_count"]
    benchmark:
        "benchmarks/analysis/jellyfish_count/{sample}.tsv"
    log:
        out = "logs/analysis/jellyfish_count/{sample}.out",
        err = "logs/analysis/jellyfish_count/{sample}.err"
    conda:
         "../envs/analysis_jellyfish.yaml"
    threads: 5
    resources: 
        mem_mb=35000,
        runtime=lambda w, attempt: f"{12 * attempt} h",
    shell:
        """
        (zcat {input.illu_1} {input.illu_2} | jellyfish count /dev/fd/0 {params.config} -t {threads} -o {output}) 1> {log.out} 2> {log.err}

        """

rule jellyfish_histo:
    input:
        "results/analysis/jellyfish/{sample}/{sample}_illu_count.jf"
    output:
        "results/analysis/jellyfish/{sample}/{sample}_illu_histo.jf"
    params:
        config = config["jellyfish_histo"]
    benchmark:
        "benchmarks/analysis/jellyfish_histo/{sample}_histo.tsv"
    log:
        out = "logs/analysis/jellyfish_histo/{sample}.out",
        err = "logs/analysis/jellyfish_histo/{sample}.err"
    conda:
         "../envs/analysis_jellyfish.yaml"
    threads: 1
    resources: 
        mem_mb=10000,
        runtime=lambda w, attempt: f"{1 * attempt} h",
    shell:
        """
        jellyfish histo {params.config} -t {threads} {input} > {output} 2> {log.err}

        """