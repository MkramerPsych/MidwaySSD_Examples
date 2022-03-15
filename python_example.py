'''
python_example.py - an example Python script for HPC demonstration

BLRB Presentation, 3/15/22

Max Kramer, BrainBridge Lab (mkramer1@uchicago.edu)

This script is intended to serve as a demo for a task a researcher may
want to use an HPC for, such as running a split half correlation analysis
to gauge the consistency of responses to a set of stimuli.

To run this script as a job on MidwaySSD, run the associated
'python_example.sbatch' script by running:

sbatch python_example.sbatch

To run this script in an interactive session, copy it to MidwaySSD
and run an interactive session using the ThinLinc GUI and run:

module load python
conda activate BLRB_environment
python python_example.py
'''
import pandas as pd
import numpy as np
import csv
import sys

# Response codings
HIT = 1
COMISSION_ERR = 2
STOP = 0
OMISSION_ERR = 3

def split_half_corr(path_to_data,N=1000):
	'''
	Perform a split half correlation analysis on a set of
	data and return the average correlation across N iterations

	Inputs:
		path_to_data(string): a path to a .csv file containing data
		N(int): the number of  iterations desired

	Returns:
		rho(float): the average split half correlation
	'''

	# read in data using pandas
	df = pd.read_csv(path_to_data,header=None)

 	# set number of subjects and number of split halves
	n_subj = len(df.columns)
	n_cols = n_subj//2

	# MAIN LOOP - Calculate Split-Half Consistency
	corrected_r_vals = [];

	for run in range(N):
		cols_s1 = np.random.permutation(n_cols)
		cols_s2 = np.setdiff1d(df.columns,cols_s1)

		# get data for the random halves
		first_half = df.loc[:,cols_s1]
		second_half = df.loc[:,cols_s2]

		# calculate hit rate
		first_half_hits = np.sum(first_half == HIT,1)
		first_half_tot = (np.sum(first_half == HIT,1) + np.sum(first_half == COMISSION_ERR,1))
		first_half_hr = np.divide(first_half_hits,first_half_tot)

		second_half_hits = np.sum(second_half == HIT,1)
		second_half_tot = (np.sum(second_half == HIT,1) + np.sum(second_half == COMISSION_ERR,1))
		second_half_hr = np.divide(second_half_hits,second_half_tot)

		# calculate false alarm rate
		first_half_stops = np.sum(first_half == STOP,1)
		first_half_tot = (np.sum(first_half == STOP,1) + np.sum(first_half == OMISSION_ERR,1))
		first_half_far = np.divide(first_half_stops,first_half_tot)

		second_half_stops = np.sum(second_half == STOP,1)
		second_half_tot = (np.sum(second_half == STOP,1) + np.sum(second_half == OMISSION_ERR,1))
		second_half_far = np.divide(second_half_stops,second_half_tot)

		# calculate corrected recognition
		cr_first = first_half_hr - first_half_far
		cr_second = second_half_hr - second_half_far

		# correlate split half cr scores and store
		r_val = np.ma.corrcoef(cr_first,cr_second) # handles NaN values
		corrected_r_vals.append(r_val)

	rho = np.mean(corrected_r_vals)
	return rho

# Run split-half correlation
rho = split_half_corr('toy_data.csv',int(sys.argv[1]))
print('rho: {}'.format(rho))
