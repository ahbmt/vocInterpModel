close all
clc

% This script compares the open-circuit voltage estimates obtained from the
% curve fit against the experimental cc discharge data

%%
load('interpData.mat')
% The naming convention used in this script is preserved from the paper.

%%
figure(1)
grid on
hold on
plot(soc1,feval(cell1poly,soc1),'r','LineWidth',1.5)
plot(soc1,feval(cell1interp,soc1),'b','LineWidth',1.5)
plot(soc1,vocDsample1,'--k','LineWidth',1.5)
legend('Polynomial','Interpolated','Experimental data')
xlabel('SOC (%)')
ylabel('v_{oc}')

%%
figure(2)
grid on
hold on
plot(soc2,feval(cell2poly,soc2),'r','LineWidth',1.5)
plot(soc2,feval(cell2interp,soc2),'b','LineWidth',1.5)
plot(soc2,vocDsample2,'--k','LineWidth',1.5)
legend('Polynomial','Interpolated','Experimental data')
xlabel('SOC (%)')
ylabel('v_{oc}')

%%
figure(3)
grid on
hold on
plot(soc3,feval(cell3poly,soc3),'r','LineWidth',1.5)
plot(soc3,feval(cell3interp,soc3),'b','LineWidth',1.5)
plot(soc3,vocDsample3,'--k','LineWidth',1.5)
legend('Polynomial','Interpolated','Experimental data')
xlabel('SOC (%)')
ylabel('v_{oc}')
