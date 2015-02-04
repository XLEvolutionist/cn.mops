#!/bin/bash
#SBATCH -D /group/jrigrp4/cn.mops/TIL_data/bams
#SBATCH -o /group/jrigrp4/cn.mops/logs/out_log-%j.txt
#SBATCH -e /group/jrigrp4/cn.mops/logs/err_log-%j.txt
#SBATCH -J filter
#SBATCH  --cpus-per-task 1
#SBATCH --array=0-3


echo "Starting Job: "
date

files=(*.bam)

file=${files[$SLURM_ARRAY_TASK_ID]}
cmd="samtools view -bhq 30 $file > filtered_$file"
echo $cmd
eval $cmd

echo "Ending Job: "
date

