% MATLAB_example.m - an example MATLAB script for HPC demonstration
%
% BLRB Presentation, 3/15/22
%
% Max Kramer, BrainBridge Lab (mkramer1@uchicago.edu)
%
% This script is intended to serve as a demo for a task a researcher may
% want to use an HPC for, such as running a split half correlation analysis
% to gauge the consistency of responses to a set of stimuli.
%
% To run this script as a job on MidwaySSD, run the associated
% 'MATLAB_example.sbatch' script by running:
%
% sbatch MATLAB_example.sbatch
%
% To run this script in an interactive session, copy it to MidwaySSD and
% run an interactive session using the ThinLinc GUI and open MATLAB.
%

%% Setup: Initialize key variables

load('toy_data.csv'); % load in toy data

% codes for responses
HIT = 1;
COMISSION_ERR = 2;
STOP = 0;
OMISSION_ERR = 3;

n_subj = size(toy_data,2); % get number of subjects
ncol = n_subj/2; % get number of columns per half

%% Main Loop - Calculate Split-Half Correlation

num_runs = 1000;
corrected_r_vals = zeros(1,num_runs);

for run = 1:num_runs

    %disp(['Run ' num2str(run)]);

    % get two random halves of subjects
    cols_s1 = randperm(n_subj,ncol); % randomly sample half w/o repeats
    cols_s2 = setdiff([1:n_subj],cols_s1); % get remaining half

    % get data for the random halves
    first_half = toy_data(:,cols_s1); % sample matrix
    second_half = toy_data(:,cols_s2); % sample matrix

    % calculate hit rate
    first_half_hr = sum(first_half == HIT, 2) ./ ...
        (sum(first_half == HIT,2) + sum(first_half == COMISSION_ERR,2));

    firsthalves{1,run} = first_half_hr';

    second_half_hr = sum(second_half == HIT, 2) ./ ...
        (sum(second_half == HIT,2) + sum(second_half == COMISSION_ERR,2));

    secondhalves{1,run} = second_half_hr';

    % calculate false alarm rate
    first_half_far = sum(first_half == STOP, 2) ./ ...
        (sum(first_half == STOP,2) + sum(first_half == OMISSION_ERR,2));

    second_half_far = sum(second_half == STOP, 2) ./ ...
        (sum(second_half == STOP,2) + sum(second_half == OMISSION_ERR,2));

    % calculate corrected recognition (hits - false alarms)
    cr_first = first_half_hr - first_half_far;
    cr_second = second_half_hr - second_half_far;

    % store corrected correlation value
    r_val = corr(cr_first,cr_second,'rows','complete');
    corrected_r_vals(1,run) = (2 * r_val) / (1 + r_val);
end

X = sprintf('rho: %d', mean(corrected_r_vals));
X
exit
