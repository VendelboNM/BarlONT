rule download_genomic_resources:
    output:
        morex_fasgz="results/genomic_resources/morex/MorexV3.fasta.gz",
        morex_fas=temp("results/genomic_resources/morex/MorexV3.fasta"),
        morex_bed="results/genomic_resources/morex/MorexV3.bed",
        morex_gff="results/genomic_resources/morex/MorexV3.gff",
        morex_zip=temp("temp/genomic_resources/morex.zip"),
        morex_tmp = temp(multiext("temp/genomic_resources/morex/", "Barley_MorexV3_pseudomolecules.fasta", "Barley_MorexV3_pseudomolecules_AGP.bed", "ReadMe__Barley_Morex_v3_transposon_annotation_by_homology.txt", "repeat_classification_PGSB_REcat-v4.tab.txt", "MorexV3_centromere_positions.tsv", "TEanno-v1.0__200416_MorexV3_pseudomolecules.gff")),
        morex_hv = temp(multiext("temp/genomic_resources/morex/Hv_Morex.pgsb.Jul2020", ".gff3", ".HC.cds_longest.fa", ".LC.cds.fa", ".aa.fa", ".HC.aa.fa", ".HC.gff3", ".LC.gff3", ".cds.fa", ".HC.cds.fa", ".LC.aa.fa")),
    log:
        "logs/genomic_resources/morexv3.out",
    benchmark:
        "benchmarks/genomic_resources/morexv3.tsv"
    params:
        morex_url="https://wheat.pw.usda.gov/GG3/sites/default/files/data_downloads/barley-morex3.zip",
        morex_dir=lambda w, output: os.path.dirname(output.morex_tmp[0]),
    conda:
        "../envs/genomic_resources.yaml"
    threads: 1
    resources:
        mem_mb=2000,
        runtime=lambda w, attempt: f"{1 * attempt} d",
    shell:
        """
        ### Initiate download - MorexV3
        (wget --no-check-certificate -O {output.morex_zip} {params.morex_url}
        unzip -o -j {output.morex_zip} "mascher@IPK-GATERSLEBEN.DE/Pseudomolecules and annotation of the third version of the reference genome sequence assembly of barley cv. Morex \\[Morex V3\\]/*" -d {params.morex_dir}
        gzip -c {params.morex_dir}/Barley_MorexV3_pseudomolecules.fasta > {output.morex_fasgz}
        cp {params.morex_dir}/Barley_MorexV3_pseudomolecules.fasta {output.morex_fas}
        cat {params.morex_dir}/Barley_MorexV3_pseudomolecules_AGP.bed > {output.morex_bed}
        cat {params.morex_dir}/Hv_Morex.pgsb.Jul2020.HC.gff3 > {output.morex_gff}
        ) > {log} 2>&1
        """
