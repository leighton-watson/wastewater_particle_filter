%% Synthetics %%
%
% Run synthetic test of particle filtering model

clear all; clc;
set(0,'DefaultAxesFontSize',14);
set(0,'DefaultLineLineWidth',2);
cmap = get(gca,'ColorOrder');

% addpath 
addpath ../../model/
definePaths()

%% Define parameters to create synthetic data

% time
t = 1:150;

% reproduction number
R1 = 0.5*(1+erf((t-30)/8))+0.1;
R2 = 0.6*(1-erf((t-60)/8));
Rsynth = R1 + R2 - 0.2;

% case ascertainment
CARsynth = 0.2*sin(t/50+pi/2)+0.5;

%% Run forward model

% initialize parameters
alpha = 600; % scaling from infections to genome copies in wastewater
P = initParams(alpha);
P.N_PARTICLES = 1e4; % reduce number of particles so that it runs faster
P.TMAX = max(t);
P.tIn = 10;

% synthetic data
cases0 = 100;
CASEDATA0.COUNT = repmat(cases0,P.tIn,1);
WWDATA0.COUNT = CASEDATA0.COUNT * P.alpha;
[R,RHO,I,WW,L] = initVar(P,CASEDATA0,WWDATA0);

[I,WW,L,~] = covidForwardModel(P,Rsynth,I,WW,L); % run forward model to compute synthetic wastewater and cases

%% run particle filtering inverse model
WWDATA.COUNT = prctile(WW,50); % produce synthetic data for wastewater
CASEDATA.COUNT = prctile(L,50).*CARsynth; % produce synthetic data for case
infect = prctile(I,50);

figHand = figure(1); clf;

WEIGHT = {'C','W','CW'}; % weighting for particle filtering
titleStr = {'(a) Input: Cases','(b) Input: Wastewater','(c) Input: Case & Wastewater',...
    '(d) Input: Cases','(e) Input: Wastewater','(f) Input: Case & Wastewater'};
for j = 1:length(WEIGHT)
    P.WEIGHT = WEIGHT{j};
    [R,RHO,~,~,~] = initVar(P,CASEDATA,WWDATA);
    [R,RHO,I,WW,L,T,ESS] = covidParticleFilter_synthetic(P,CASEDATA,WWDATA,R,RHO,I,WW,L); % run particle filter
    figure(1);

    % plot synthetic reproduction number
    subplot(2,3,j);
    plot(t,Rsynth,'k--')
    hold on; grid on
    xlabel('Time (days)')
    ylabel('R_{eff} Number')
    ylim([0 2.5])
    vline(P.tIn);

    % plot inversion results
    R5 = prctile(R,5);
    R50 = prctile(R,50);
    R95 = prctile(R,95);
    h = fill([t fliplr(t)],[R5 fliplr(R95)],cmap(j,:));
    set(h,'FaceAlpha',0.3)
    set(h,'EdgeColor',cmap(j,:));
    plot(T,R50,'Color',cmap(j,:));

    DR(j) = norm(Rsynth-R50);
  
    % plot synthetic case ascertainment rate
    subplot(2,3,3+j);
    plot(t,CARsynth,'k--')
    hold on; grid on
    xlabel('Time (days)')
    ylabel('Case Ascertainment Rate')
    ylim([0 1])
    vline(P.tIn);
    
    % plot inversion results
    RHO5 = prctile(RHO,5);
    RHO50 = prctile(RHO,50);
    RHO95 = prctile(RHO,95);
    h = fill([t fliplr(t)],[RHO5 fliplr(RHO95)],cmap(j,:));
    set(h,'FaceAlpha',0.3)
    set(h,'EdgeColor',cmap(j,:));
    plot(T,RHO50,'Color',cmap(j,:));

    DCAR(j) = norm(CARsynth-RHO50);

end


for i = 1:6
    figure(1);
    subplot(2,3,i);
    title(titleStr{i});
end






