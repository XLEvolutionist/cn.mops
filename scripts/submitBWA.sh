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

cmd="bwa mem -M -t 10 -v 1 /group/jrigrp4/teosinte_parents/genomes/Zea_mays.AGPv3.22.dna.genome.fa <(zcat TIL11_3511_3807_3511_N_TIP534_3_R1.fastq.gz)  | samtools view -bS - > TIL11.bam"
echo $cmd
eval $cmd
cmd="samtools sort TIL11.bam TIL11_sorted"
echo $cmd
eval $cmd

echo "Job Ending: "
date

