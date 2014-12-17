#!/bin/bash -l
#!/bin/bash
#OUTDIR=/group/jrigrp4/cn.mops/output
#SBATCH -D /group/jrigrp4/cn.mops/output
#SBATCH -o /group/jrigrp4/cn.mops/logs/index_out_log-%j.txt
#SBATCH -e /group/jrigrp4/cn.mops/logs/index_err_log-%j.txt
#SBATCH -J index
#SBATCH --array=0-19
#SBATCH --mem-per-cpu=8000

##Simon Renny-Byfield, UC Davis, December 16 2014


echo "Starting Job:"
date

files=($(ls -d ../data/*sorted.bam))

#now index each .bam file

cmd="samtools index ${files[$SLURM_ARRAY_TASK_ID]}"
echo $cmd
eval $cmd

echo "End Job: "
date
