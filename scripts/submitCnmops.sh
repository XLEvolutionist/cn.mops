#!/bin/bash
#OUTDIR=/group/jrigrp4/cn.mops/output
#SBATCH -D /group/jrigrp4/cn.mops/output
#SBATCH -o /group/jrigrp4/cn.mops/logs/cn.mops_out_log-%j.txt
#SBATCH -e /group/jrigrp4/cn.mops/logs/cn.mops_err_log-%j.txt
#SBATCH -J cn.mops
#SBATCH --mem=100000

export R_LIBS="~/R/x86_64-pc-linux-gnu-library/3.1"

echo "Starting cn.mops job: "
date

cmd="Rscript ../scripts/cnv_cnmpos.R"
echo $cmd
eval $cmd

echo "Job Ending: "
date

