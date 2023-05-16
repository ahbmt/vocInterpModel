close all
clc

% This script compares the battery voltage obtained from the
% hybrid RV-ECM model against the experimental PRBS discharge data

%% Load experiment 
load('cleanPRBSData.mat')

%% Load model data
% The naming convention used here comes from the battery tags. The paper
% correspondence is as follows:
% cell 8 = battery 1
% cell 9 = battery 2
% cell 10 = battery 3
load('cellModel_IP.mat')
cell8Model = cell8Model_IP;
cell9Model = cell9Model_IP;
cell10Model = cell10Model_IP;

%% Initial conditions for the SOC and model
m = 1:1:10; % Number of terms of the diffusion model
sigmaDelInit = 0; % Delivered charge
sigmaUnvInit = 0; % Unavailable charge
sigmaInit = 0; % Total charge spent
socInit = 100; % State of Charge
downsampleN = 1; % Set downsample, if needed, if not, set to 1

startSim = 300;
endSim = 30000;

v10 = v10 - 0.0084;
v9 = v9 - 0.00262;
v8 = v8 - 0.00210;

%% Cell 8
fprintf('Running pulsed current simulation for cell 8 ...\n')
[cell8Err, ...
 cell8vEstim, ...
 cell8vData] = batDiscreteSim(downsampleN, ...
                              i8(startSim:endSim), ...
                              v8(startSim:endSim), ...
                              t8(startSim:endSim), ...
                              cell8Model.rs, ...
                              cell8Model.vocFit, ...
                              cell8Model.alpha, ...
                              cell8Model.beta, ...
                              m,...
                              cell8Model.r1, ...
                              cell8Model.c1, ...
                              sigmaDelInit, ...
                              sigmaUnvInit,...
                              sigmaInit, ...
                              socInit);
cell8ErrPct = 100*abs((cell8vData-cell8vEstim)./cell8vData);
fprintf('Average simulation error for cell 8 = %d pct.\n',mean(cell8ErrPct))
fprintf('Peak simulation error for cell 8 = %d pct.\n',max(cell8ErrPct))
%% Cell 9
fprintf('Running pulsed current simulation for cell 9 ...\n')
[cell9Err, ...
 cell9vEstim, ...
 cell9vData] = batDiscreteSim(downsampleN, ...
                              i9(startSim:endSim), ...
                              v9(startSim:endSim), ...
                              t9(startSim:endSim), ...
                              cell9Model.rs, ...
                              cell9Model.vocFit, ...
                              cell9Model.alpha, ...
                              cell9Model.beta, ...
                              m,...
                              cell9Model.r1, ...
                              cell9Model.c1, ...
                              sigmaDelInit, ...
                              sigmaUnvInit,...
                              sigmaInit, ...
                              socInit);
cell9ErrPct = 100*abs((cell9vData-cell9vEstim)./cell9vData);
fprintf('Average simulation error for cell 9 = %d pct.\n',mean(cell9ErrPct))
fprintf('Peak simulation error for cell 9 = %d pct.\n',max(cell9ErrPct))
%% Cell 10
fprintf('Running pulsed current simulation for cell 10 ...\n')
[cell10Err, ...
 cell10vEstim, ...
 cell10vData] = batDiscreteSim(downsampleN, ...
                               i10(startSim:endSim), ...
                               v10(startSim:endSim), ...
                               t10(startSim:endSim), ...
                               cell10Model.rs, ...
                               cell10Model.vocFit, ...
                               cell10Model.alpha, ...
                               cell10Model.beta, ...
                               m,...
                               cell10Model.r1, ...
                               cell10Model.c1, ...
                               sigmaDelInit, ...
                               sigmaUnvInit,...
                               sigmaInit, ...
                               socInit);
cell10ErrPct = 100*abs((cell10vData-cell10vEstim)./cell10vData);
fprintf('Average simulation error for cell 10 = %d pct.\n',mean(cell10ErrPct))
fprintf('Peak simulation error for cell 10 = %d pct.\n',max(cell10ErrPct))
%% Comparison plots
close all
fprintf('Plotting results.\n')
% Cell 8
figure(1)
hold on
grid on
plot(t8(startSim:endSim),cell8vEstim,'r','LineWidth',1.5)
plot(t8(startSim:endSim),cell8vData,'--k','LineWidth',1.5)
legend('Pulsed test \beta','Experiment data')
xlabel('Time, t(s)')
ylabel('v_b(V)')
title('Cell 8')
xlim([0 t8(endSim)])

figure(2)
hold on
grid on
plot(t8(startSim:endSim),cell8ErrPct,'r','LineWidth',1.5)
plot(t8(startSim:endSim),ones(length(t8(startSim:endSim)),1)*mean(cell8ErrPct), ...
     '--k','LineWidth',1.5)
legend('Error','Mean')
xlabel('Time, t(s)')
ylabel('Error(%)')
title('Cell 8')
xlim([0 t8(endSim)])


% Cell 9
figure(3)
hold on
grid on
plot(t9(startSim:endSim),cell9vEstim,'g','LineWidth',1.5)
plot(t9(startSim:endSim),cell9vData,'--k','LineWidth',1.5)
legend('Pulsed test \beta','Experiment data')
xlabel('Time, t(s)')
ylabel('v_b(V)')
title('Cell 9')
xlim([0 t9(endSim)])

figure(4)
hold on
grid on
plot(t9(startSim:endSim),cell9ErrPct,'g','LineWidth',1.5)
plot(t9(startSim:endSim),ones(length(t9(startSim:endSim)),1)*mean(cell9ErrPct), ...
     '--k','LineWidth',1.5)
legend('Error','Mean')
xlabel('Time, t(s)')
ylabel('Error(%)')
title('Cell 9')
xlim([0 t9(endSim)])

% Cell 10
figure(5)
hold on
grid on
plot(t10(startSim:endSim),cell10vEstim,'b','LineWidth',1.5)
plot(t10(startSim:endSim),cell10vData,'--k','LineWidth',1.5)
legend('Pulsed test \beta','Experiment data')
xlabel('Time, t(s)')
ylabel('v_b(V)')
title('Cell 10')
xlim([0 t10(endSim)])

figure(6)
hold on
grid on
plot(t10(startSim:endSim),cell10ErrPct,'b','LineWidth',1.5)
plot(t10(startSim:endSim),ones(length(t10(startSim:endSim)),1)*mean(cell10ErrPct), ...
     '--k','LineWidth',1.5)
legend('Error','Mean')
xlabel('Time, t(s)')
ylabel('Error(%)')
title('Cell 10')
xlim([0 t10(endSim)])



