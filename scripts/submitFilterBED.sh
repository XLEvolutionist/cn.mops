#!/bin/bash
#SBATCH -D /group/jrigrp4/cn.mops/data/filtered_genes10
#SBATCH -o /group/jrigrp4/cn.mops/logs/out_log-%j.txt
#SBATCH -e /group/jrigrp4/cn.mops/logs/err_log-%j.txt
#SBATCH -J filter
#SBATCH  --cpus-per-task 1
#SBATCH --array=0-21


echo "Starting Job: "
date
cd ../
files=(*sorted.bam)
cd filtered_genes10

file=${files[$SLURM_ARRAY_TASK_ID]}
cmd="samtools view -bh -q 10 -L /group/jrigrp4/freec/maize3/GeneZeaRefV3.bed ../$file > filtered_$file"
echo $cmd
eval $cmd

echo "Ending Job: "
date

