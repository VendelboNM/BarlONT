import os

#### Rule-specific time estimation 
# Time for each rule is based on linear model regression using historic job resource usage data and set to fit the 90% percentile

# Step 1: Processing
def estimate_time_fastp(wildcards, attempt):
    r1_path = f"{config['data']}/illu/{wildcards.sample}_1_illu_raw.fastq.gz"
    r2_path = f"{config['data']}/illu/{wildcards.sample}_2_illu_raw.fastq.gz"
    input_file = [r1_path, r2_path]
    input_size = sum(os.path.getsize(f) for f in input_file)
    # convert from bytes to gigabytes
    input_size_gb = input_size / (1024 * 1024 * 1024)
    # Add illumina data scaling (* 2.25 is for the Gbp to .gz compressed filesize scaling -- e.g. 2.5 Gbp sample ~ 1 GBytes) 
    estimate_time_fastp = ((19.26 + (input_size_gb * 2.25) * 0.1) * 60)/8
    return attempt * int(estimate_time_fastp)

def estimate_time_nanoqc(wildcards, attempt):
    input_file = f"{config['data']}/ont/{wildcards.sample}_ont_raw.fastq.gz"
    input_size = os.path.getsize(input_file)
    # convert from bytes to gigabytes
    input_size_gb = input_size / (1024 * 1024 * 1024)
    # Add nanopore data scaling (* 1.1 is for the Gbp to .gz compressed filesize scaling -- e.g. 1.1 Gbp sample ~ 1 GBytes) 
    estimate_time_nanoqc = ((-0.23 + (input_size_gb * 3) * 0.1) * 60)/5
    return attempt * int(estimate_time_nanoqc)

def estimate_time_nanoplot(wildcards, attempt):
    input_file = f"{config['data']}/ont/{wildcards.sample}_ont_raw.fastq.gz"
    input_size = os.path.getsize(input_file)
    # convert from bytes to gigabytes
    input_size_gb = input_size / (1024 * 1024 * 1024)
    # Add nanopore data scaling (* 1.1 is for the Gbp to .gz compressed filesize scaling -- e.g. 1.1 Gbp sample ~ 1 GBytes) 
    estimate_time_nanoplot = (1.1 * input_size_gb * 0.5 * 60)/5
    return attempt * int(estimate_time_nanoplot)

def estimate_time_porechop(wildcards, attempt):
    input_file = f"{config['data']}/ont/{wildcards.sample}_ont_raw.fastq.gz"
    input_size = os.path.getsize(input_file)
    # convert from bytes to gigabytes
    input_size_gb = input_size / (1024 * 1024 * 1024)
    # Add nanopore data scaling (* 1.1 is for the Gbp to .gz compressed filesize scaling -- e.g. 1.1 Gbp sample ~ 1 GBytes) 
    estimate_time_porechop = (-16.6 + (input_size_gb * 2.5) * 60)/15
    return attempt * int(estimate_time_porechop)

def estimate_time_chopper(wildcards, attempt):
    input_file = f"{config['data']}/ont/{wildcards.sample}_ont_raw.fastq.gz"
    input_size = os.path.getsize(input_file)
    # convert from bytes to gigabytes
    input_size_gb = input_size / (1024 * 1024 * 1024)
    # Add nanopore data scaling (* 1.1 is for the Gbp to .gz compressed filesize scaling -- e.g. 1.1 Gbp sample ~ 1 GBytes) 
    estimate_time_chopper = ((4.15 + (input_size_gb * 6) * 0.2) * 60)/5
    return attempt * int(estimate_time_chopper)

def estimate_time_filtlong(wildcards, attempt):
    input_file = f"{config['data']}/ont/{wildcards.sample}_ont_raw.fastq.gz"
    input_size = os.path.getsize(input_file)
    # convert from bytes to gigabytes
    input_size_gb = input_size / (1024 * 1024 * 1024)
    # Add nanopore data scaling (* 1.1 is for the Gbp to .gz compressed filesize scaling -- e.g. 1.1 Gbp sample ~ 1 GBytes) 
    estimate_time_filtlong = (1.1 * input_size_gb * 60)/1
    return attempt * int(estimate_time_filtlong)

# Step 2: Assembly
def estimate_time_flye(wildcards, attempt):
    input_file = f"{config['data']}/ont/{wildcards.sample}_ont_raw.fastq.gz"
    input_size = os.path.getsize(input_file)
    # convert from bytes to gigabytes
    input_size_gb = input_size / (1024 * 1024 * 1024)
    # Add nanopore data scaling (* 1.1 is for the Gbp to .gz compressed filesize scaling -- e.g. 1.1 Gbp sample ~ 1 GBytes) 
    estimate_time_flye = ((-2242 + (input_size_gb * 1.1) * 99.2)* 60)/48
    return attempt * int(estimate_time_flye)

# Step 3: Polishing
def estimate_time_nextpolish(wildcards, attempt):
    r1_path = f"{config['data']}/illu/{wildcards.sample}_1_illu_raw.fastq.gz"
    r2_path = f"{config['data']}/illu//{wildcards.sample}_2_illu_raw.fastq.gz"
    input_file = [r1_path, r2_path]
    input_size = sum(os.path.getsize(f) for f in input_file)
    # convert from bytes to gigabytes
    input_size_gb = input_size / (1024 * 1024 * 1024)
    # Add illumina data scaling (* 2.25 is for the Gbp to .gz compressed filesize scaling -- e.g. 2.5 Gbp sample ~ 1 GBytes) 
    estimate_time_fastp = ((781 + (input_size_gb * 35)) * 60)/30
    return attempt * int(estimate_time_fastp)

def estimate_time_ntedit(wildcards, attempt):
    r1_path = f"{config['data']}/illu/{wildcards.sample}_1_illu_raw.fastq.gz"
    r2_path = f"{config['data']}/illu//{wildcards.sample}_2_illu_raw.fastq.gz"
    input_file = [r1_path, r2_path]
    input_size = sum(os.path.getsize(f) for f in input_file)
    # convert from bytes to gigabytes
    input_size_gb = input_size / (1024 * 1024 * 1024)
    # Add illumina data scaling (* 2.25 is for the Gbp to .gz compressed filesize scaling -- e.g. 2.5 Gbp sample ~ 1 GBytes) 
    estimate_time_fastp = ((input_size_gb * 0.4) * 60)/5
    return attempt * int(estimate_time_fastp)

# Step 4: Variant calling
def estimate_time_bwa_align(wildcards, attempt):
    estimate_time_fastp = ((19.26 + (input_size_gb * 2.25) * 0.1) * 60)/8
    return attempt * int(estimate_time_fastp)