rule nanoplot_raw:
    input:
        os.path.join(config["data"],"ont/{sample}_ont_raw.fastq.gz"),
    output:
        multiext(
            "results/01_processing/nanoplot/{sample}/raw/",
            "LengthvsQualityScatterPlot_dot.html",
#            "LengthvsQualityScatterPlot_dot.png",
            "LengthvsQualityScatterPlot_kde.html",
#            "LengthvsQualityScatterPlot_kde.png",
            "NanoPlot-data.tsv.gz",
            "NanoPlot-report.html",
            "NanoStats.txt",
            "Non_weightedHistogramReadlength.html",
#            "Non_weightedHistogramReadlength.png",
            "Non_weightedLogTransformed_HistogramReadlength.html",
#            "Non_weightedLogTransformed_HistogramReadlength.png",
            "WeightedHistogramReadlength.html",
#            "WeightedHistogramReadlength.png",
            "WeightedLogTransformed_HistogramReadlength.html",
#            "WeightedLogTransformed_HistogramReadlength.png",
            "Yield_By_Length.html",
#            "Yield_By_Length.png",
        ),
    params:
        outdir = lambda w, output: os.path.dirname(output[0])
    log:
        "logs/01_processing/nanoplot/{sample}/raw.out",
    benchmark:
        "benchmarks/01_processing/nanoplot/{sample}/raw.tsv"
    conda:
        "../envs/01_nanoplot.yaml"
    threads: 5
    resources: 
        mem_mb=5000,
        runtime=estimate_time_nanoplot
    shell:
        """
        NanoPlot --threads {threads} --raw --tsv_stats --fastq {input} -o {params.outdir} > {log} 2>&1
        """

use rule nanoplot_raw as nanoplot_processed with:
    input:
        "results/01_processing/filtlong/{sample}_ont_processed.fastq.gz"
    output:
        multiext(
            "results/01_processing/nanoplot/{sample}/processed/",
            "LengthvsQualityScatterPlot_dot.html",
 #           "LengthvsQualityScatterPlot_dot.png",
            "LengthvsQualityScatterPlot_kde.html",
 #           "LengthvsQualityScatterPlot_kde.png",
            "NanoPlot-data.tsv.gz",
            "NanoPlot-report.html",
            "NanoStats.txt",
            "Non_weightedHistogramReadlength.html",
 #           "Non_weightedHistogramReadlength.png",
            "Non_weightedLogTransformed_HistogramReadlength.html",
 #           "Non_weightedLogTransformed_HistogramReadlength.png",
            "WeightedHistogramReadlength.html",
 #           "WeightedHistogramReadlength.png",
            "WeightedLogTransformed_HistogramReadlength.html",
 #           "WeightedLogTransformed_HistogramReadlength.png",
            "Yield_By_Length.html",
 #           "Yield_By_Length.png",
        ),
    params:
        outdir = lambda w, output: os.path.dirname(output[0])
    log:
        "logs/01_processing/nanoplot/{sample}/processed.out",
    benchmark:
        "benchmarks/01_processing/nanoplot/{sample}/processed.tsv"
