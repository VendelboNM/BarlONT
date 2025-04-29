rule nanoqc_raw:
    input:
        os.path.join(config["data"],"ont", "{sample}_ont_raw.fastq.gz"),
    output:
        nanoqc_html = "results/01_processing/nanoqc/{sample}/{sample}_ont_nanoqc_raw.html",
        nanoqc_log = "results/01_processing/nanoqc/{sample}/{sample}_ont_nanoqc_raw.log"
    log:
        "logs/01_processing/nanoqc/{sample}/raw.out",
    benchmark:
        "benchmarks/01_processing/nanoqc/{sample}/raw.tsv"
    params:
        outdir = lambda w, output: os.path.dirname(output[0])
    conda:
        "../envs/01_nanoqc.yaml"
    threads: 5
    resources: 
        mem_mb=40000,
        runtime=estimate_time_nanoqc
    shell:
        """
        (
        nanoQC -o {params.outdir} {input}

        # Renaming of output files
        mv {params.outdir}/nanoQC.html {output.nanoqc_html}
        mv {params.outdir}/NanoQC.log {output.nanoqc_log}
        ) > {log} 2>&1
        """


use rule nanoqc_raw as nanoqc_processed with:
    input:
        "results/01_processing/filtlong/{sample}_ont_processed.fastq.gz",
    output:
        nanoqc_html = "results/01_processing/nanoqc/{sample}/{sample}_ont_nanoqc_processed.html",
        nanoqc_log = "results/01_processing/nanoqc/{sample}/{sample}_ont_nanoqc_processed.log"
    log:
        "logs/01_processing/nanoqc/{sample}/processed.out",
    benchmark:
        "benchmarks/01_processing/nanoqc/{sample}/processed.tsv"
