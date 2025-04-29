rule porechop:
    input:
        ont = os.path.join(config["data"],"ont", "{sample}_ont_raw.fastq.gz"),
        nanoplot_summary = "results/01_processing/nanoplot/{sample}/raw/NanoStats.txt",
        nanoqc_html = "results/01_processing/nanoqc/{sample}/{sample}_ont_nanoqc_raw.html",
        genomescope2 = "results/analysis/genomescope2/{sample}/summary.txt",
    output:
        temp("results/01_processing/porechop/{sample}_ont_porechop.fastq.gz"),
    params:
        outdir = lambda w, output: os.path.dirname(output[0])
    benchmark:
        "benchmarks/01_processing/porechop/{sample}.tsv"
    log:
        out = "logs/01_processing/porechop/{sample}.out",
        err = "logs/01_processing/porechop/{sample}.err"
    conda:
        "../envs/01_porechop.yaml"
    threads: 15
    resources: 
        mem_mb=375000,
        runtime=estimate_time_porechop
    shell:
        """
        porechop_abi -abi -t {threads} -i {input.ont} -o {output} -tmp {resources.tmpdir}/tmp_{wildcards.sample} 1> {log.out} 2> {log.err}

        """