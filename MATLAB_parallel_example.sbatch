#!/bin/bash
#SBATCH --job-name=MATLAB_ex   # Specify name for job [do not use spaces]
#SBATCH --time=00:05:00        # Specify maximum time [Program will terminate after max time if not complete, default is 36:00:00]
#SBATCH --partition=ssd        # Specify partition [Should always be ssd]
#SBATCH --account=ssd          # Account [should always be set to ssd]
#SBATCH --nodes=1              # Number of nodes [Number of physical machines to request, determines other parameters]
#SBATCH --ntasks-per-node=4    # Number of tasks [Number of processing cores per node requested, 1=single threaded, 2+=multi threaded]
#SBATCH --cpus-per-task=1      # Number of threads per task [Should be one unless using MPI]
#SBATCH --mem=1gb	       # Amount of RAM [May need to run interactive first to find correct number, DO NOT set unreasonably high]
#SBATCH --output=MAT_par.out   # Name of output file [Can change jobname to suit whatever job you run]
#SBATCH --error=MAT_par.err    # Name of error file [Can change jobname to suit whatever job you run]


#LOAD MODULES
module load matlab

# Create a temporary directory on scratch
mkdir -p $SCRATCH/$USER/$SLURM_JOB_ID

# EXECUTE JOB [Run whatever code you want using the resources you requested]
matlab -nodisplay < MATLAB_example.m

# Cleanup local work directory
rm -rf $SCRATCH/$USER/$SLURM_JOB_ID
