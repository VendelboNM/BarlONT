#!/usr/bin/env Rscript

# Define log files
logdir <- snakemake@params[["logdir"]]
err_file <- file(paste0(logdir, "/data_qc.err"), open = "wt")
sink(err_file, type = "message")

# Install packages
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2", repos = "https://cran.rstudio.com/")
}

# Load packages
library("ggplot2")

# Import filtration parameters
state <- snakemake@params[["state"]]
line <- snakemake@params[["sample"]]
minlen <- snakemake@params[["min_length"]]
datadir <- snakemake@params[["datadir"]]
outdir <- snakemake@params[["outdir"]]

# Set minimum read length (raw = 0)
minlength <- 0

### Print parameters to log.out file
lt <- 0
technology <- "ont"

for (s in 1:length(state)) {
  log_out <- c(paste0("Step: Data QC, ", state[s]), "Run Parameters:", "")
  for (l in 1:length(line)) {
    log_out <- c(log_out, paste0("Sample: ", line[l]))
    ## Print log.out
    log_out <- c(log_out, paste0("Technology: ONT"))
    lt <- lt + 1
    data_lt <- paste0(datadir, "/ont/", state[s], "/hv_", line[l], "/hv_", line[l], "_ont_", state[s], "NanoPlot-data.tsv")
    log_out <- c(log_out, paste0("Data: ", data_lt))
    outdir_lt <- paste0(outdir, "/ont/hv_", line[l])
    log_out <- c(log_out, paste0("Outdir: ", outdir_lt))

    # Create directories
    dir.create(outdir_lt, recursive = TRUE)

    # Define filtration parameters
    minlength <- as.numeric(minlen)

    ### STEP 1: Process raw read data from nanoplot
    # Lead data & merge datasets into one data.frame
    df <- read.delim2(data_lt, head = TRUE)
    cultivar_id <- line[l]
    read_quality <- df[1]
    read_length <- df[2]
    read_length_kb <- as.numeric(read_length$lengths) / 1000
    tech <- rep("ont", nrow(df))
    tech_cultivar <- rep(paste0("ont_", cultivar_id[1]), nrow(df))
    cultivar <- gsub(
      "em2", "Emir",
      gsub(
        "ig1", "Rohane-03",
        gsub("sc1", "Scarlett", cultivar_id)
      )
    )
    df <- data.frame(technology, cultivar_id, cultivar, tech_cultivar, read_length, read_length_kb, read_quality)
    colnames(df)[5] <- c("read_length_bp")
    colnames(df)[7] <- c("read_quality")
    df$read_quality <- as.numeric(df$read_quality)

    # Create data.frame with (1) read number (2) mean read length + SD, (3) longest read (4) mean read quality + SD
    reads <- round(as.numeric(nrow(df) / 10^6), digits = 1)
    bases <- round(sum((df$read_length_kb) / 10^6), digits = 2)
    median_len <- round(median(df$read_length_kb, na.rm = TRUE), digits = 1)
    mean_len <- round(mean(df$read_length_kb, na.rm = TRUE), digits = 1)
    sd_len <- round(sd(df$read_length_kb, na.rm = TRUE), digits = 1)
    max_len <- round(max(df$read_length_kb), digits = 1)
    q_median <- round(median(df$read_quality, na.rm = TRUE), digits = 1)
    q_mean <- round(mean(df$read_quality, na.rm = TRUE), digits = 1)
    q_sd <- round(sd(df$read_quality, na.rm = TRUE), digits = 1)
    tech <- "ont"
    cultivar <- df$cultivar[1]
    stats <- data.frame(technology, state[s], cultivar_id, cultivar, reads, bases, max_len, median_len, mean_len, sd_len, q_median, q_mean, q_sd)

    colnames(stats) <- c("Technology", "State", "Cultivar ID", "Cultivar", "Reads (Mio.)", "Bases sequenced (Gb)", "Longest read (kb)", "Median read length (kb)", "Mean read length (kb)", "Read length SD", "Median read quality", "Mean read quality", "Read quality SD")
    write.table(stats, paste0(outdir_lt, "/hv_", line[l], "_ont_", state[s], "_nanoplot_stats.csv"), sep = ";", dec = ",", row.names = FALSE, col.names = TRUE, quote = FALSE)

    # Create data.frame with detailed read size metrics
    int <- c(5, 10, 20, 40, 60, 80, 100)

    for (k in 1:length(int)) {
      if (k == 1) {
        df_k <- df[which(df$read_length_kb <= int[k]), ]
        size_k <- round((nrow(df_k) / nrow(df)) * 100, digits = 1)
        data_k <- round(((sum(df_k$read_length_bp) / 10^9) / bases) * 100, digits = 2)
        df_met <- data.frame(technology, state[s], cultivar_id, cultivar, size_k, data_k)
        colnames(df_met) <- c("Technology", "State", "Cultivar ID", "Cultivar", paste0("% Reads 0-5 kb"), paste0("% Data 0-5 kb"))
      } else {
        df_k <- df[which(df$read_length_kb > int[k - 1] & df$read_length_kb <= int[k]), ]
        size_k <- round((nrow(df_k) / nrow(df)) * 100, digits = 1)
        data_k <- round(((sum(df_k$read_length_bp) / 10^9) / bases) * 100, digits = 2)
        interval <- paste0(k, "-", k + 1)
        df_met_k <- data.frame(size_k, data_k)
        colnames(df_met_k) <- c(paste0("% Reads ", int[k - 1], "-", int[k], " kb"), paste0("% Data ", int[k - 1], "-", int[k], " kb"))
        df_met <- cbind(df_met, df_met_k)
      }
    }

    write.table(df_met, paste0(outdir_lt, "/hv_", line[l], "_ont_", state[s], "_nanoplot_size_stats.csv"), sep = ";", dec = ",", row.names = FALSE, col.names = TRUE, quote = FALSE)

    ### Output histogram of read length distribution for each of the assemblies
    bin_size <- 2 # Read bin size (kb)
    end <- 100 # End of read histogram (kb)
    for (k in 1:((end / bin_size) - 1)) {
      if (k == 1) {
        df_k <- df[(which(df$read_length_kb < bin_size)), ]
        int_start <- 0
        int_end <- bin_size
      } else {
        df_k <- df[(which(df$read_length_kb > bin_size * k & df$read_length_kb <= bin_size * (k + 1))), ]
        int_start <- bin_size * k
        int_end <- bin_size * (k + 1)
      }
      interval <- paste0(int_start, "-", int_end)
      quality <- as.numeric(round(mean(df_k$read_quality, na.rm = TRUE), digits = 2))
      count <- nrow(df_k)
      frequency <- round((nrow(df_k) / nrow(df) * 100), digits = 2)
      data_total <- sum(df$read_length_kb) / 10^6
      data_gb <- round(sum(df_k$read_length_kb) / 10^6, digits = 2)
      data_relative <- round((data_gb / data_total) * 100, digits = 1)
      quality <- as.numeric(round(mean(df_k$read_quality, na.rm = TRUE), digits = 1))
      df_k <- data.frame(int_start, int_end, interval, count, frequency, data_gb, data_relative, quality)
      if (k == 1) {
        df_sum <- df_k
      } else {
        df_sum <- rbind(df_sum, df_k)
      }
    }
    colnames(df_sum) <- c("Start (kb)", "End (kb)", "Interval", "Read size count", "Read bin proportion (%)", "Data (gb)", "Data proportion (%)", "Mean quality")
    write.table(df_sum, paste0(outdir_lt, "/hv_", line[l], "_ont_", state[s], "_nanoplot_hist.csv"), sep = ";", dec = ",", row.names = FALSE, col.names = TRUE, quote = FALSE)

    ### GRAPHICAL OUTPUT ###

    ## First graph: read length (0-10 kb) distribution
    filename <- paste0(outdir_lt, "/hv_", line[l], "_ont_", state[s], "_hist_length_97.5perc.png")
    ggplot(df, aes(x = read_length_kb)) +
      geom_histogram(binwidth = 0.25) +
      xlim((minlength / 1000), ceiling(quantile(df$read_length_kb, 0.975, na.rm = TRUE))) +
      scale_y_continuous(labels = scales::comma) +
      ggtitle(paste0("Read length distribution of hv_", line[l], "_ont_", state[s])) +
      ylab("Frequency") +
      xlab("Read length (kb)")

    ggsave(filename, plot = last_plot(), width = 6, height = 4, dpi = 300)

    ## Second graph: read length distribution
    filename <- paste0(outdir_lt, "/hv_", line[l], "_ont_", state[s], "_hist_length.png")
    ggplot(df, aes(x = read_length_kb)) +
      geom_histogram(binwidth = 0.25) +
      scale_y_continuous(labels = scales::comma) +
      ggtitle(paste0("Read length distribution of hv_", line[l], "_ont_", state[s])) +
      ylab("Frequency") +
      xlab("Read length (kb)")
    ggsave(filename, plot = last_plot(), width = 6, height = 4, dpi = 300)

    ## Third graph: read quality distribution
    filename <- paste0(outdir_lt, "/hv_", line[l], "_ont_", state[s], "_hist_quality.png")
    ggplot(df, aes(x = read_quality)) +
      geom_histogram(binwidth = 0.25) +
      scale_y_continuous(labels = scales::comma) +
      ggtitle(paste0("Read quality distribution of hv_", line[l], "_ont_", state[s])) +
      ylab("Frequency") +
      xlab("Read quality")
    ggsave(filename, plot = last_plot(), width = 6, height = 4, dpi = 300)

    ## Fourth graph: read length distribution
    filename <- paste0(outdir_lt, "/hv_", line[l], "_ont_", state[s], "_read_dist.png")
    interval <- as.factor(df_sum$Interval)
    read <- df_sum$`Read bin proportion (%)`
    mydata <- data.frame(interval, read)
    mydata$interval <- factor(c(mydata$interval), levels = mydata$interval)

    ggplot(mydata, aes(y = read, x = interval)) +
      geom_bar(stat = "identity") +
      ggtitle(paste0("Read distribution of hv_", line[l], "_ont_", state[s])) +
      scale_y_continuous(labels = scales::comma) +
      ylab("Read proportion (%)") +
      xlab("Read Length (kb)") +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
    ggsave(filename, plot = last_plot(), width = 6, height = 4, dpi = 300)

    ## Fifth graph: data distribution
    filename <- paste0(outdir_lt, "/hv_", line[l], "_ont_", state[s], "_data_dist.png")
    interval <- as.factor(df_sum$Interval)
    gb <- df_sum$`Data proportion (%)`
    mydata <- data.frame(interval, gb)
    mydata$interval <- factor(c(mydata$interval), levels = mydata$interval)

    ggplot(mydata, aes(y = gb, x = interval)) +
      geom_bar(stat = "identity") +
      ggtitle(paste0("Data distribution of hv_", line[l], "_ont_", state[s])) +
      scale_y_continuous(labels = scales::comma) +
      ylab("Data proportion (%)") +
      xlab("Read Length (kb)") +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
    ggsave(filename, plot = last_plot(), width = 6, height = 4, dpi = 300)
    log_out <- c(log_out, paste0(""))
  }
  write.table(log_out, file = paste0(logdir, "/data_qc_", state[s], ".out"), quote = FALSE, row.names = FALSE, col.names = FALSE)
}

# Close the log files
sink(type = "message")
close(err_file)
