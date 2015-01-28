#!/bin/bash
#OUTDIR=/group/jrigrp4/cn.mops/output
#SBATCH -D /group/jrigrp4/cn.mops/output
#SBATCH -o /group/jrigrp4/cn.mops/logs/cn.mops_out_log-%j.txt
#SBATCH -e /group/jrigrp4/cn.mops/logs/cn.mops_err_log-%j.txt
#SBATCH -J BEDtools

echo "Starting cn.mops job: "
date

cmd="bedtools coverage -d -abam ../TIL_data/TIL01_sorted.bam -b ../SWgenes.gff > SW_coverage "
eval $cmd

echo "Job Ending: "
date
