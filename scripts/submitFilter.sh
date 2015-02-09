#!/bin/bash
#SBATCH -D /group/jrigrp4/cn.mops/data/filtered_bams10
#SBATCH -o /group/jrigrp4/cn.mops/logs/out_log-%j.txt
#SBATCH -e /group/jrigrp4/cn.mops/logs/err_log-%j.txt
#SBATCH -J filter
#SBATCH  --cpus-per-task 1
#SBATCH --array=0-20


echo "Starting Job: "
date
cd ../
files=(*.bam)
cd filtered_bams10

file=${files[$SLURM_ARRAY_TASK_ID]}
cmd="samtools view -bhq 10 ../$file > filtered_$file"
echo $cmd
eval $cmd

echo "Ending Job: "
date
