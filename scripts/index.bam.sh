#!/bin/bash -l
#!/bin/bash
#OUTDIR=/group/jrigrp4/cn.mops/data/filtered_bams
#SBATCH -D /group/jrigrp4/cn.mops/data/filtered_bams10
#SBATCH -o /group/jrigrp4/cn.mops/logs/index_out_log-%j.txt
#SBATCH -e /group/jrigrp4/cn.mops/logs/index_err_log-%j.txt
#SBATCH -J index
#SBATCH --array=0-20
#SBATCH --mem-per-cpu=8000

##Simon Renny-Byfield, UC Davis, December 16 2014
# modified Feb` 15

echo "Starting Job:"
date

files=(*.bam)

#now index each .bam file

cmd="samtools index ${files[$SLURM_ARRAY_TASK_ID]}"
echo $cmd
eval $cmd

echo "End Job: "
date
