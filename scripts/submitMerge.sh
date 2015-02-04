#!/bin/bash
#OUTDIR=/group/jrigrp4/cn.mops/output
#SBATCH -D /group/jrigrp4/cn.mops/output/run1
#SBATCH -o /group/jrigrp4/cn.mops/logs/cn.mops_out_log-%j.txt
#SBATCH -e /group/jrigrp4/cn.mops/logs/cn.mops_err_log-%j.txt
#SBATCH -J cn.merge
#SBATCH --mem=100000
#SBATCH --cpus-per-task=2

echo "Starting Job:"
date

cmd="Rscript ../../scripts/combine_chrCalls.R"
eval $cmd

echo "Ending Job:"
date
