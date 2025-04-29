
rule ntedit:
    input:
        draft = "results/03_polishing/nextpolish/{sample}/AP2_{sample}.fasta",
        reads = expand("results/01_processing/fastp/{sample}_{read}_illu_processed.fastq.gz", read=[1,2], allow_missing=True),
    output:
        bf = "results/03_polishing/ntedit/{sample}/AP3_{sample}.bf",
        hist = "results/03_polishing/ntedit/{sample}/AP3_{sample}.hist",
        fas = "results/03_polishing/ntedit/{sample}/AP3_{sample}.fasta",
        tsv = "results/03_polishing/ntedit/{sample}/AP3_{sample}.tsv",
        vcf = "results/03_polishing/ntedit/{sample}/AP3_{sample}.vcf",
    params:
        config = config["ntedit"],
        in_prefix = lambda w, input: os.path.basename(os.path.commonprefix(input.reads)),
    log:
        "logs/03_polishing/ntedit/{sample}.out",
    benchmark:
        "benchmarks/03_polishing/ntedit/{sample}.tsv"
    conda:
        "../envs/03_ntedit.yaml"
    shadow: "shallow"
    threads: 5
    resources: 
        mem_mb=80000,
        runtime=estimate_time_ntedit,
    shell:
        """
        (
        ln -sf {input.reads[0]} .
        ln -sf {input.reads[1]} .
        run-ntedit polish -t {threads} --draft {input.draft} --reads {params.in_prefix} {params.config} --solid
        mv *.bf {output.bf}
        mv *.hist {output.hist}
        mv *.fa {output.fas}
        mv *.tsv {output.tsv}
        mv *.vcf {output.vcf}
        ) > {log} 2>&1
        """
