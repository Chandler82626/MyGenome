#!/bin/bash

#SBATCH --time 8:00:00
#SBATCH --job-name=GenomePostProcess
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --partition=normal
#SBATCH --mem=180GB
#SBATCH --mail-type ALL
#SBATCH	-A cea_farman_s26abt480
#SBATCH --mail-type ALL
#SBATCH --mail-user farman@uky.edu,LinkBlueID@uky.edu

echo "SLURM_NODELIST: "$SLURM_NODELIST
echo "PWD :" $PWD


# Arguments

genome=$1
prefix=${genome/_*/}
basename=${prefix/*\//}

cp -r /project/farman_s26abt480/RESOURCES .

# identify adaptors
module load ccs/conda/python/3.9.6
export FCS_LOC="/share/apps/amd/fcs/adaptor"
outdir=${basename}_FCS
mkdir $outdir
$FCS_LOC/run_fcsadaptor.sh --fasta-input $genome --output-dir $outdir \
 --euk --container-engine singularity --image $FCS_LOC/fcs-adaptor.sif

# trim/remove adaptors and contigs < 200 nt in length
export FCS_DEFAULT_IMAGE=RESOURCES/fcs-gx.sif
cat $genome | python3 RESOURCES/fcs.py clean genome \
  --action-report ${basename}_FCS/fcs_adaptor_report.txt --output ${basename}_final.fasta




