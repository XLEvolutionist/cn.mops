#!/bin/bash
#OUTDIR=/group/jrigrp4/cn.mops/output
#SBATCH -D /group/jrigrp4/cn.mops/TIL_data
#SBATCH -o /group/jrigrp4/cn.mops/logs/bwa_out_log-%j.txt
#SBATCH -e /group/jrigrp4/cn.mops/logs/bwa_err_log-%j.txt
#SBATCH -J bwa
#SBATCH --mem=10000
#SBATCH --cpus-per-task 10


echo "Starting bwa job: "
date

cmd="bwa mem -M -t 10 -v 1 /home/vince251/data/refgen3-hapmap/maize3.fa.gz TIL01_3510_3807_3510_N_TIP521_4_R1.fastq TIL01_3510_3807_3510_N_TIP521_4_R2.fastq  | samtools view -bSh  - > TIL01.bam"
echo $cmd
eval $cmd
cmd="samtools sort TIL01.bam TIL01_sorted"
echo $cmd
eval $cmd
cmd="samtools index TIL01_sorted.bam"
echo $cmd
eval $cmd

echo "Job Ending: "
date

