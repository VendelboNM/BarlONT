# BarlONT Snakemake Workflow:

A Snakemake pipeline for de novo hybrid assembly and structural variant calling in barley using Oxford Nanopore and Illumina reads.

BarlONT will generate a polished assembly, extensive QC reporting and both short- & long-read sequence guided structural variants. 

## Software requirements

#### [Conda =< 24.11.2](https://docs.conda.io/en/latest/)
```
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

#### [Snakemake =< 8.16.0](https://snakemake.readthedocs.io/en/stable/)
```
conda install -c bioconda -c conda-forge snakemake
```

#### [FindGSE](https://github.com/schneebergerlab/findGSE)
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
&nbsp;&nbsp;&nbsp;&nbsp;The pipeline directory contains the BarlONT snakemake pipeline such as rules, conda environments, scripts, etc. needed for running BarlONT. 

#### Run directory: snakemake/barlont_run
&nbsp;&nbsp;&nbsp;&nbsp;The run directory (just a folder within the same directive as the barlont folder), contains the run output such as results, log and benchmark files generated during a BarlONT run or multiple runs. This directive structure allows for multiple run directives to be generated and initiated using different run parameters or samples. 

<p>&nbsp;</p>

## Setting up and executing BarlONT
Follow these steps to set up and execute the BarlONT pipeline:

#### Step 1: Clone the repository
```
git clone https://github.com/VendelboNM/BarlONT.git "$(pwd)/snakemake/barlont"
```

#### Step 2: Set up the workflow and configuration

```
# Create a run directive (e.g. barlont_run)
mkdir /snakemake/barlont_run

# Copy the config folder to the run directive
cp -r /snakemake/barlont/config /snakemake/barlont_run
```

#### Step 3: Update the configuration
Within /snakemake/barlont_run/config/config.yaml file edit the:   
&nbsp;&nbsp;&nbsp;&nbsp; (1) Path for raw sequence data   
&nbsp;&nbsp;&nbsp;&nbsp; (2) Sample ids

#### Step 4: Execute BarlONT
```
snakemake \
    --jobs {insert maximum number of parallel jobs} \
    --snakefile ../barlont/workflow/ont_processing.smk \
    --configfile config/config.yaml \
    --software-deployment-method conda \
    --use-conda \
    --conda-prefix {path to conda directive} \
    --printshellcmds \
    --latency-wait 120 \
    --keep-going \
    --verbose \
    --notemp
```
<p>&nbsp;</p>

## Running BarlONT on SLURM

BarlONT can be efficiently executed on SLURM, a widely used job scheduler for high-performance computing clusters. This allows for parallel execution, optimized resource management, and seamless integration with cluster environments.

#### Install [executor plugin for slurm](https://snakemake.github.io/snakemake-plugin-catalog/plugins/executor/slurm.html)
```
pip install snakemake-executor-plugin-slurm
```
#### Executing snakefile on SLURM
```
snakemake \
        --jobs {insert maximum number of parallel jobs} \
        --snakefile ../barlont/workflow/ont_processing.smk \
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

## Directed Acyclic Graph

![BarlONT_dag](https://github.com/user-attachments/assets/533d3be3-de67-4e06-9c1b-2441e1822dfe)


## Funding

This bioinformatic pipeline is published as part of the BarleyMicroBreed project, that has received funding from the European Union's Horizon Europe research and innovation programme under Grant Agreement No. 101060057.
