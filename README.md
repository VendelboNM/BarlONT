# Barlont Snakemake Workflow:

A Snakemake pipeline for de novo hybrid assembly and structural variant calling in barley using Oxford Nanopore and Illumina reads.

BarlONT will generate a polished assembly, extensive QC reporting and both short- & long-read sequence guided structural variants. 

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

### BarlONT directive structure

#### Pipeline directory: snakemake/barlont/workflow
The pipeline directory contains the BarlONT snakemake pipeline such as rules, conda environments, scripts, etc. needed for running BarlONT. 

#### Run directory: snakemake/barlont_run
The run directory (just a folder within the same directive as the barlont folder), contains the run output such as results, log and benchmark files generated during a BarlONT run or multiple runs. This directive structure allows for multiple run directives to be generated and initiated using different run parameters or samples. 

<p>&nbsp;</p>

## Running BarlONT

1. Copy the BarlONT workflow folder to a directive designated 'barlont' (e.g. /snakemake/barlont)
2. Copy the BarlONT config folder to a directive in the same path as the 'barlont' directive' (e.g. /snakemake/barlont_run/config)
3. Fill in the path for (1) data, and (2) sample ids in the config file (e.g. /snakemake/barlont_run/config/config.yaml)
4. Execute the BarlONT pipeline from the run directive (e.g. /snakemake/barlont_run)

<p>&nbsp;</p>

## Running BarlONT on SLURM

BarlONT can easily be executed on a job scheduler such as SLURM, often used on HPC clusters.

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
