rule nextpolish:
    input:
        fas = "results/02_assembly/flye/{sample}/AD_{sample}.fasta",
        illu_1 = "results/01_processing/fastp/{sample}_1_illu_processed.fastq.gz",
        illu_2 = "results/01_processing/fastp/{sample}_2_illu_processed.fastq.gz",
    output:
        fas = "results/03_polishing/nextpolish/{sample}/AP2_{sample}.fasta",
        stat = "results/03_polishing/nextpolish/{sample}/AP2_{sample}.stat",
        config = temp("temp/03_polishing/nextpolish/{sample}/AP2_{sample}.cfg"),
        fofn = temp("temp/03_polishing/nextpolish/{sample}/AP2_{sample}.fofn"),
    params:
        in_fas = lambda w, input: Path(input.fas).resolve(),
        out_fofn = lambda w, output: Path(output.fofn).resolve(),
        out_dir = lambda w, output: Path(output.fas).parent.resolve(),
    benchmark:
        "benchmarks/03_polishing/nextpolish/{sample}.tsv"
    log:
        "logs/03_polishing/nextpolish/{sample}.out",
    conda:
        "../envs/03_nextpolish.yaml"
    threads: 30
    resources: 
        mem_mb=200000,
        runtime=estimate_time_nextpolish,
    shell:
        """
        (
        cat <<EOF > {output.config};
[General]
job_type = local
job_prefix = nextPolish
task = best
rewrite = yes
rerun = 2
parallel_jobs = 6
multithread_jobs = 5
genome = {params.in_fas}
genome_size = auto
workdir = {params.out_dir}

[sgs_option]
sgs_fofn = {params.out_fofn}
sgs_options = "-max_depth 100 -bwa"
EOF

        # Create sgs.fofn file
        realpath {input.illu_1} {input.illu_2} > {output.fofn};
        cat {output.config};
        # Run nextpolish
        nextPolish {output.config};
        # Rename files
        mv {params.out_dir}/genome.nextpolish.fasta {output.fas};
        mv {params.out_dir}/genome.nextpolish.fasta.stat {output.stat};
        ) > {log} 2>&1
        """
