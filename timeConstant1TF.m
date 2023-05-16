function [numDtc1,denDtc1] = timeConstant1TF(r1,c1,ts)

s = tf('s');
sysC = (1/c1)/(s+(1/(r1*c1)));
sysD = c2d(sysC,ts);
[numDtc1,denDtc1]=tfdata(sysD,'v');
end