#!/bin/bash
#OUTDIR=/group/jrigrp4/cn.mops/output
#SBATCH -D /group/jrigrp4/cn.mops/data
#SBATCH -o /group/jrigrp4/cn.mops/logs/bwa_out_log-%j.txt
#SBATCH -e /group/jrigrp4/cn.mops/logs/bwa_err_log-%j.txt
#SBATCH -J bwa
#SBATCH --mem=10000
#SBATCH --cpus-per-task 10


echo "Starting bwa job: "
date

cmd="bwa mem -M -t 10 -v 1 -p /home/vince251/data/refgen3-hapmap/maize3.fa.gz B73_fastq/b73.fastq | samtools view -bSh  - > B73.bam"
echo $cmd
eval $cmd
cmd="samtools sort B73.bam B73_sorted"
echo $cmd
eval $cmd
cmd="samtools index B73_sorted.bam"
echo $cmd
eval $cmd

echo "Job Ending: "
date

