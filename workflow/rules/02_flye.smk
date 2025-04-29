rule flye:
    input:
        filtlong = "results/01_processing/filtlong/{sample}_ont_processed.fastq.gz",
        nanoplot_summary = "results/01_processing/nanoplot/{sample}/processed/NanoStats.txt",
        nanoqc_html = "results/01_processing/nanoqc/{sample}/{sample}_ont_nanoqc_processed.html",
    output:
        "results/02_assembly/flye/{sample}/AD_{sample}.fasta"
    params:
        config = config["flye"],
        genome_size = config["genome_size"],
        outdir = lambda w, output: os.path.dirname(output[0])
    benchmark:
        "benchmarks/02_assembly/flye/{sample}.tsv"
    log:
        out = "logs/02_assembly/flye/{sample}.out",
        err = "logs/02_assembly/flye/{sample}.err"
    conda:
        "../envs/02_flye.yaml"
    threads: 48
    resources: 
        mem_mb=850000,
        runtime=estimate_time_flye
    shell:
        """
        if [[ -f {params.outdir}/params.json ]]; then
            flye --resume --nano-hq {input.filtlong} {params.config} -t {threads} -g {params.genome_size}g -o {params.outdir} 1> {log.out} 2> {log.err}
        else
            flye --nano-hq {input.filtlong} {params.config} -t {threads} -g {params.genome_size}g -o {params.outdir} 1> {log.out} 2> {log.err}
        fi
        
        # Rename output files 
        mv {params.outdir}/assembly.fasta {output} 1>> {log.out} 2>> {log.err}

        """