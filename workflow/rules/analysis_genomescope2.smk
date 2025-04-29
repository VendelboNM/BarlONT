rule genomescope:
    input:
        hist= "results/analysis/jellyfish/{sample}/{sample}_illu_histo.jf",
    output:
        multiext(
            "results/analysis/genomescope2/{sample}/",
            "linear_plot.png",
            "log_plot.png",
            "model.txt",
            "progress.txt",
            "SIMULATED_testing.tsv",
            "summary.txt",
            "transformed_linear_plot.png",
            "transformed_log_plot.png",
        ),
    log:
        "logs/analysis/genomescope2/{sample}.log",
    params:
        extra=config["genomescope2"],
    conda:
        "../envs/analysis_genomescope2.yaml",
    log:
        "logs/analysis/genomescope2/{sample}.out",
    benchmark:
        "benchmarks/analysis/genomescope2/{sample}.tsv",
    threads: 1,
    resources: 
        mem_mb=2000,
        runtime=lambda w, attempt: f"{1 * attempt} h",
    wrapper:
        f"{wrapper_ver}/bio/genomescope"
