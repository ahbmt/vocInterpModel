function [err, ...
          vEstim, ...
          vData] = batDiscreteSim(downsampleN, ...
                                  iExp, ...
                                  vExp, ...
                                  tExp, ...
                                  rs, ...
                                  vocFit, ...
                                  alpha, ...
                                  beta, ...
                                  m,...
                                  r1, ...
                                  c1, ...
                                  sigmaDelInit, ...
                                  sigmaUnvInit,...
                                  sigmaInit, ...
                                  socInit)

%% Downsampling of the experiment data
ts = (tExp(2)-tExp(1))*downsampleN; % Simulation time step, in s
iData = downsample(iExp,downsampleN); % Downsample experiment data, current
vData = downsample(vExp,downsampleN); % Downsample experiment data, voltage
time = downsample(tExp,downsampleN); % Downsample experiment data, time

%% Vector setup
sigmaDel = zeros(length(time),1);
sigmaUnv = zeros(length(time),length(m));
sigma = zeros(length(time),1);
soc = zeros(length(time),1);
voc = zeros(length(time),1);
vEstim = zeros(length(time),1);
vRC1 = zeros(length(time),1);

%% Definition of the initial state of the battery
sigmaDel(1) = sigmaDelInit; % Delivered charge
sigmaUnv(1,:) = sigmaUnvInit; % Unavailable charge
sigma(1) = sigmaInit; % Total charge spent
soc(1) = socInit; % State of Charge
voc(1) = feval(vocFit,socInit); % Open circuit voltage
vEstim(1) = feval(vocFit,socInit); % Battery voltage
vRC1(1) = 0;

%% Discrete-time battery simulation
for k=2:1:length(time)
    
    % Expression of the delivered charge
    sigmaDel(k) = iData(k)*ts + sigmaDel(k-1);
    
    % Expression of the unavailable charge
    sigmaUnv(k,:) = exp(-(beta^2)*(m.^2)*ts).*sigmaUnv(k-1,:) - iData(k)*((exp(-(beta^2)*(m.^2)*ts)-1)./((beta^2)*(m.^2)));

    % Expression of the total charge spent
    sigma(k) = sigmaDel(k) + 2*sum(sigmaUnv(k,:));

    % Expression of the State of Charge
    soc(k) = 100*((alpha - sigma(k))/alpha);
    
    % Expression of the open circuit voltage
    voc(k) = feval(vocFit,soc(k));
    
    % Expression of the voltage for the first RC branch
%     vRC1(k) = (r1/(ts+r1*c1))*(iData(k)*ts+c1*vRC1(k-1));
    vRC1(k) = exp(-ts/(r1*c1))*vRC1(k-1) - r1*(exp(-ts/(r1*c1))-1)*iData(k);
    
    % Expression of the battery voltage
    vEstim(k) = voc(k) - rs*iData(k) - vRC1(k);
    
end

%% MSE between estimated and experimental data
err = immse(vData,vEstim);
