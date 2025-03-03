# Barlont Snakemake Workflow:

A Snakemake pipeline for de novo hybrid assembly and structural variant calling in barley using Oxford Nanopore and Illumina reads.

## Software requirements


#### Conda =< 24.11.2
```
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

#### Snakemake =< 8.16.0
```
conda install -c bioconda -c conda-forge snakemake
```

#### FindGSE 
```
# Download
wget https://github.com/schneebergerlab/findGSE/archive/master.zip
unzip master.zip
tar -czvf findGSE-master.tar.gz findGSE-master/

# Install
R
install.packages("findGSE-master.tar.gz")
```

## Sequence data requirements

BarlONT was developed using:

#### Oxford Nanopore Technologies (ONT)

&nbsp;&nbsp;&nbsp;&nbsp; R10.4.1 ONT long-read sequence dataset (>60 Gigabase) with median read length of ~12 kb and median read quality of ~19.

#### Illumina paired-end (PE150)

&nbsp;&nbsp;&nbsp;&nbsp; Illumina 150 bp paired-end dataset (>120 Gigabase).
<p>&nbsp;</p>

## Getting started


<p>&nbsp;</p>

### BarlONT directive structure

Pipeline directory: snakemake/barlont/workflow
Run directory: snakemake/barlont_run

The pipeline directory contains the BarlONT snakemake pipeline, rules, conda environments, scripts, etc. needed for running BarlONT. The run directory (just a folder within the same directive as the barlont folder), contains the run output (results, log, benchmark, etc. files) generated during a BarlONT run or multiple runs. This directive structure allows for multiple run directives to be generated and run using different run parameters or samples. 

<p>&nbsp;</p>

## Running on SLURM

#### Install executor plugin for slurm (https://snakemake.github.io/snakemake-plugin-catalog/plugins/executor/slurm.html)
```
pip install snakemake-executor-plugin-slurm
```
#### Executing snakefile on SLURM
```
snakemake \
        --jobs {insert maximum number of parallel jobs} \
        --snakefile {path to barlont snakefile} \
        --configfile config/config.yaml \
        --software-deployment-method conda \
        --use-conda \
        --conda-prefix {path to conda directive} \
        --printshellcmds \
        --latency-wait 120 \
        --keep-going \
        --executor slurm \
        --default-resources slurm_account={account name} slurm_partition={partition name} tmpdir=temp \
	--max-jobs-per-timespan 100/1s \
	--verbose \
	--notemp
```

<p>&nbsp;</p>

## Quick Tips








<p>&nbsp;</p>

## Citation

Please cite out paper at: 

<p>&nbsp;</p>

## Funding

This bioinformatic pipeline is published as part of the BarleyMicroBreed project, that has received funding from the European Union's Horizon Europe research and innovation programme under Grant Agreement No. 101060057.
