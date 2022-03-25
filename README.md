# Introduction to High Performance Computing for Neuroscience Research
## BLRB Cluster, University of Chicago
---
This repository contains slides and files from Max Kramer's 3/15/22 BLRB Presentation entitled 'Introduction to High Performance Computing for Neuroscience Research'. 

Contents:
- `BLRB_Presentation_3_15_MK.pdf` : Presentation slides
- `toy_data.csv` : A .csv file containing randomly generated data for the split-half consistency example scripts
- `environment.yml` : An anaconda environment file for the Python scripts in this repository, can run on MidwaySSD
- `MATLAB_example.m` : An example MATLAB script for running split-half consistency on MidwaySSD
- `MATLAB_parallel_example.m` : Similar to `MATLAB_example.m`, except using MATLAB's  `parfor` command for parallel processing
- `python_example.py` : An example Python script for running split-half consistency on MidwaySSD
- `matlab_example.sbatch` : A SLURM batch script for running `MATLAB_example.m` on MidwaySSD as a scheduled job
- `MATLAB_parallel_example.sbatch` : A SLURM batch script for running `MATLAB_parallel_example.m` on MidwaySSD as a scheduled job, includes parallel processing
- `python_example.sbatch` : A SLURM batch script for running `python_example.py` on MidwaySSD as a scheduled job
