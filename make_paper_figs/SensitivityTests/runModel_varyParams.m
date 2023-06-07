%% make figure real world
%
% run model for real world data and plot results

clear all; clc;
set(0,'DefaultAxesFontSize',14);
set(0,'DefaultLineLineWidth',2);
cmap = get(gca,'ColorOrder');

%% initialization

% addpath 
addpath ../../model/
definePaths()

% initialize parameters
%PARAM = [1 10 100]; % for cases
PARAM = [1 10 50]; % for ww
alpha = 3e9;
for i = 1:length(PARAM)
    
    P = initParams(alpha);
    P.START_DATE_PLOT = datetime("2022-01-01");
    P.START_DATE = datetime("2021-11-01");
    P.norm_idx = days(P.START_DATE_PLOT - P.START_DATE);
    P.N_PARTICLES = 1e3; % reduce number of particles so that it runs faster

    %P.SIGMA_RHO = PARAM(i);
    %P.SIGMA_R = PARAM(i);
    %P.WEIGHT = PARAM{i};
    %P.kc = PARAM(i);
    P.kw = PARAM(i);
    
    % load data
    [P,CASEDATA,WWDATA] = loadData(P);

    % initialize variables
    [R,RHO,I,WW,L] = initVar(P,CASEDATA,WWDATA);
    
    %% run model
    tic
    [R,RHO,I,WW,L,TIME,T,ESS] = covidParticleFilter(P,CASEDATA,WWDATA,R,RHO,I,WW,L);
    toc

    %% save outputs
  
    % reproduction number
    subplot(3,1,1);
    R5 = prctile(R,5);
    R50 = prctile(R,50);
    R95 = prctile(R,95);

    % absolute CAR
    subplot(3,1,2);
    ACAR5 = prctile(RHO,5);
    ACAR50 = prctile(RHO,50);
    ACAR95 = prctile(RHO,95);

    % relative CAR
    subplot(3,1,3);
    CAR5 = prctile(RHO./RHO(:,P.norm_idx),5);
    CAR50 = prctile(RHO./RHO(:,P.norm_idx),50);
    CAR95 = prctile(RHO./RHO(:,P.norm_idx),95);

    % infections
    I5 = prctile(I,5);
    I50 = prctile(I,50);
    I95 = prctile(I,95);

    % cumulative infections
    CI5 = cumsum(I5);
    CI50 = cumsum(I50);
    CI95 = cumsum(I95);  

    % cases
    R0 = P.kc;
    mu = L.*RHO;
    P0 = R0./(mu+R0);
    preInd = nbinrnd(R0,P0);
    L5 = prctile(preInd,5);
    L50 = prctile(preInd,50);
    L95 = prctile(preInd,95);

    % wastewater
    a = P.kw;
    b = WW/a;
    preInd = gamrnd(a,b);
    WW5 = prctile(preInd,5);
    WW50 = prctile(preInd,50);
    WW95 = prctile(preInd,95);
    
%     % save outputs
%     filename = "sigma_R_" + num2str(i+2) + ".mat";
%     save(filename,'R5','R50','R95',...
%         'ACAR5','ACAR50','ACAR95',...
%         'CAR5','CAR50','CAR95',...
%         'I5','I50','I95',...
%         'CI5','CI50','CI95',...
%         'L5','L50','L95',...
%         'WW5','WW50','WW95',...
%         'TIME','P',...
%         'CASEDATA','WWDATA');
end



