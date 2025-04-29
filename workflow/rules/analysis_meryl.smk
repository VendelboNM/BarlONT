rule meryl_count:
    input:
        os.path.join(config["data"],"ont/{sample}_ont_raw.fastq.gz"),
    output:
        directory("results/analysis/meryl/{sample}/{sample}_ont_count.meryl")
    params:
        command="count",
        extra = config["meryl_count"],
    log:
         "logs/analysis/meryl_count/{sample}.log",
    benchmark:
        "benchmarks/analysis/meryl_count/{sample}.tsv"
    conda:
        "../envs/meryl.yaml"
    threads: 5
    resources:
        mem_mb=100000,
        runtime=lambda w, attempt: f"{2 * attempt} d",
    wrapper:
        f"{wrapper_ver}/bio/meryl/count"


rule meryl_histo:
    input:
        rules.meryl_count.output[0],
    output:
        "results/analysis/meryl/{sample}/{sample}_ont_histo.meryl"
    params:
        command="histogram",
    log:
        "logs/analysis/meryl_histogram/{sample}.log",
    benchmark:
        "benchmarks/analysis/meryl_histogram/{sample}.tsv"
    conda:
        "../envs/meryl.yaml"
    threads: 1
    resources:
        mem_mb=2000,
        runtime=lambda w, attempt: f"{1 * attempt} h",
    wrapper:
        f"{wrapper_ver}/bio/meryl/stats"
