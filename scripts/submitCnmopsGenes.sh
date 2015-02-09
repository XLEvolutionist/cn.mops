#!/bin/bash
#OUTDIR=/group/jrigrp4/cn.mops/output
#SBATCH -D /group/jrigrp4/cn.mops/output/gene1
#SBATCH -o /group/jrigrp4/cn.mops/logs/cn.mops_out_log-%j.txt
#SBATCH -e /group/jrigrp4/cn.mops/logs/cn.mops_err_log-%j.txt
#SBATCH -J cn.Genes
#SBATCH --mem=100000
#SBATCH --cpus-per-task=12

export R_LIBS="~/R/x86_64-pc-linux-gnu-library/3.1"

echo "Starting cn.mops job: "
date
echo "Preverving run: "
cp  /group/jrigrp4/cn.mops/scripts/cnv_cnmposFiltered.R cnv_cnmposFiltered.R
cp /group/jrigrp4/cn.mops/scripts/combine_chrCalls.R  combine_chrCalls.R
cp /group/jrigrp4/cn.mops/scripts/compareTIL01_sw.R  compareTIL01_sw.R

cmd="Rscript /group/jrigrp4/cn.mops/scripts/cnv_cnmposGenes.R `pwd`"
echo $cmd
eval $cmd

cmd="Rscript /group/jrigrp4/cn.mops/scripts/combine_chrCalls.R `pwd`"
eval $cmd

cmd="Rscript /group/jrigrp4/cn.mops/scripts/compareTIL01_sw.R `pwd`"
eval $cmd

echo "Job Ending: "
date

