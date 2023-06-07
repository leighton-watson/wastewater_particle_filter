function [R,RHO,I,WW,L] = initVar(P,CASEDATA,WWDATA)
% function [R,RHO,I,WW,L] = initVar(P,cases,ww);

% initialize variables
R = zeros(P.N_PARTICLES, P.TMAX); % instantaneous reproduction number
I = zeros(P.N_PARTICLES, P.TMAX); % true infections
RHO = zeros(P.N_PARTICLES, P.TMAX); % case ascertainment rate
WW = zeros(P.N_PARTICLES, P.TMAX); % waste water genome copies
L = zeros(P.N_PARTICLES, P.TMAX); % infections lagged in time by incubation and reporting delays

for i = 1:P.tIn
    R(:,i) = rand(P.N_PARTICLES, 1)*2;
    I(:,i) = round(unifrnd(1*CASEDATA.COUNT(i), 5*CASEDATA.COUNT(i), P.N_PARTICLES, 1));
    RHO(:,i) = unifrnd(0.1, 0.9, P.N_PARTICLES, 1);
    WW(:,i) = WWDATA.COUNT(i);
    L(:,i) = I(:,i);
end

% % A cheap way of doing a wind-in
% R(:,2:P.tIn) = repmat(R(:,1), 1, P.tIn-1);
% I(:,2:P.tIn) = repmat(I(:,1), 1, P.tIn-1);
% RHO(:,2:P.tIn) = repmat(RHO(:,1), 1, P.tIn-1);
% WW(:,2:P.tIn) = repmat(WW(:,1), 1, P.tIn-1);
% L(:,2:P.tIn) = repmat(L(:,1), 1, P.tIn-1);



