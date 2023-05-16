clc
close all

%% Open simulink model
open('batModelSimulink.slx')
% This only needs to run the first time you run the script on each matlab
% start up. After that you can comment this line (remember to run it again
% in the next session!)

%% Load experiment and 
load('cleanPRBSData.mat')

%% Load model data
load('cellModel_IP.mat')

% Choose the desired cell model
cellModel = cell8Model_IP;

%% Simulation time step
ts = 1e-2; % The same as the data sampling rate

%% Order of the diffusion model TF
% Higher is better, at the cost of runtime. m = 10 was used during the
% model estimation phase, so a value lower than that might imply a loss in
% accuracy.
m = 10;

%% Attribute model parameters to Simulink variables
% RV modal unavailable charge 
[numD, ...
 denD, ...
 numC, ...
 denC] = betaTF(cellModel.beta, ...
                m, ...
                ts);
% RV modal total charge
alpha = cellModel.alpha;
% ECM series resistance
rs = cellModel.rs;
% ECM RC parallel circuit transfer function
[numDtc1, ...
 denDtc1] = timeConstant1TF(cellModel.r1, ...
                            cellModel.c1, ...
                            ts);
% ECM v_oc fit                        
vocFit = cellModel.vocFit;
save vocFitSimulink.mat vocFit

%% Define current source
% Define simulation start and end
startSim = 300;
endSim = 30000;
% Build input current timeseries
iTimeseries = timeseries(i8(startSim:endSim),t8(startSim:endSim));
    
%% Define experimental voltage timeseries
vbTimeseries = timeseries(v8(startSim:endSim),t8(startSim:endSim));
%% Define simulation endtime
endTime = t8(endSim);

%% Run simulation
tic
sim('batModelSimulink')
toc



