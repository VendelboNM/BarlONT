rule busco:
    input:
        fasta=lambda w: branch(w.type == "draft", then="results/02_assembly/flye/{sample}/AD_{sample}.fasta", otherwise="results/03_polishing/ntedit/{sample}/AP3_{sample}.fasta"),
    output:
        short_json="results/assembly_qc/busco/{sample}/{type}/short_summary.json",
        short_txt="results/assembly_qc/busco/{sample}/{type}/{sample}_busco_report.txt",
        full_table="results/assembly_qc/busco/{sample}/{type}/full_table.tsv",
        miss_list="results/assembly_qc/busco/{sample}/{type}/busco_missing.tsv",
        dataset_dir=directory("results/assembly_qc/busco/{type}/{sample}/dataset"),
    log:
        "logs/assembly_qc/busco/{type}/{sample}.log",
    benchmark:
        "benchmarks/assembly_qc/busco/{type}/{sample}.tsv"
    params:
        mode="genome",
        lineage="poales_odb10",
        extra=config["busco"],
    threads: 8
    resources:
        mem_mb=80000,
        runtime=lambda w, attempt: f"{5 * attempt} d"
    wrapper:
        f"{wrapper_ver}/bio/busco"


rule merqury:
    input:
        fasta=lambda w: branch(w.type == "draft", then="results/02_assembly/flye/{sample}/AD_{sample}.fasta", otherwise="results/03_polishing/ntedit/{sample}/AP3_{sample}.fasta"),
        meryldb="results/analysis/meryl/{sample}/{sample}_ont_count.meryl",
    output:
        # meryldb output
        filt="results/assembly_qc/merqury/{sample}/{type}/meryldb.filt",
        hist="results/assembly_qc/merqury/{sample}/{type}/meryldb.hist",
        hist_ploidy="results/assembly_qc/merqury/{sample}/{type}/meryldb.hist.ploidy",
        # general output
        completeness_stats="results/assembly_qc/merqury/{sample}/{type}/{sample}_merqury_stats.txt",
        dist_only_hist="results/assembly_qc/merqury/{sample}/{type}/out.dist.only.hist",
        qv="results/assembly_qc/merqury/{sample}/{type}/{sample}_merqury_qv.txt",
        spectra_asm_hist="results/assembly_qc/merqury/{sample}/{type}/out.spectra_asm.hist",
        spectra_asm_ln_png="results/assembly_qc/merqury/{sample}/{type}/out.spectra_asm.png",
        # haplotype-specific output
        fas1_only_bed="results/assembly_qc/merqury/{sample}/{type}/hap1.bed",
        fas1_only_wig="results/assembly_qc/merqury/{sample}/{type}/hap1.wig",
        fas1_only_hist="results/assembly_qc/merqury/{sample}/{type}/hap1.hist",
        fas1_qv="results/assembly_qc/merqury/{sample}/{type}/hap1.qv",
        fas1_spectra_cn_hist="results/assembly_qc/merqury/{sample}/{type}/hap1.spectra.hist",
        fas1_spectra_cn_ln_png="results/assembly_qc/merqury/{sample}/{type}/hap1.spectra.png",
    log:
        std="logs/assembly_qc/merqury/{type}/{sample}.out",
        spectra_cn="logs/assembly_qc/merqury/{type}/{sample}_haploid.spectra-cn.log",
    benchmark:
        "benchmarks/assembly_qc/merqury/{type}/{sample}.tsv"
    threads: 1
    resources: 
        mem_mb=20000,
        runtime=lambda w, attempt: f"{1 * attempt} d",
    wrapper:
        f"{wrapper_ver}/bio/merqury"


rule quast:
    input:
        fasta=lambda w: branch(w.type == "draft", then="results/02_assembly/flye/{sample}/AD_{sample}.fasta", otherwise="results/03_polishing/ntedit/{sample}/AP3_{sample}.fasta"),
        ref="results/genomic_resources/morex/MorexV3.fasta",
    output:
        report_html="results/assembly_qc/quast/{sample}/{type}/{sample}_quast_report.html",
        report_tex="results/assembly_qc/quast/{sample}/{type}/{sample}_quast_report.tex",
        report_txt="results/assembly_qc/quast/{sample}/{type}/{sample}_quast_report.txt",
        report_pdf="results/assembly_qc/quast/{sample}/{type}/{sample}_quast_report.pdf",
        report_tsv="results/assembly_qc/quast/{sample}/{type}/{sample}_quast_report.tsv",
        treport_tex="results/assembly_qc/quast/{sample}/{type}/{sample}_quast_treport.tex",
        treport_txt="results/assembly_qc/quast/{sample}/{type}/{sample}_quast_treport.txt",
        treport_tsv="results/assembly_qc/quast/{sample}/{type}/{sample}_quast_treport.tsv",
        stats_cum="results/assembly_qc/quast/{sample}/{type}/cumulative.pdf",
        stats_gc_plot="results/assembly_qc/quast/{sample}/{type}/gc.pdf",
        stats_gc_icarus="results/assembly_qc/quast/{sample}/{type}/gc.icarus.txt",
        stats_gc_fasta="results/assembly_qc/quast/{sample}/{type}/gc_fasta.pdf",
        stats_ngx="results/assembly_qc/quast/{sample}/{type}/NGx.pdf",
        stats_nx="results/assembly_qc/quast/{sample}/{type}/Nx.pdf",
        contigs="results/assembly_qc/quast/{sample}/{type}/contigs.all_alignments.tsv",
        contigs_mis="results/assembly_qc/quast/{sample}/{type}/contigs.mis_contigs.info",
        icarus="results/assembly_qc/quast/{sample}/{type}/icarus.html",
        icarus_viewer="results/assembly_qc/quast/{sample}/{type}/icarus_viewer.html",
    log:
        "logs/assembly_qc/quast/{type}/{sample}.log",
    benchmark:
        "benchmarks/assembly_qc/quast/{type}/{sample}.tsv"
    params:
        extra=config["quast"],
    threads: 5
    resources: 
        mem_mb=70000,
        runtime=lambda w, attempt: f"{12 * attempt} h",
    wrapper: 
        f"{wrapper_ver}/bio/quast"
