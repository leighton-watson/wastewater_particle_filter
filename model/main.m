%% main %%
%
% main script file that initializes the variables and parameters and then
% calls covidParticleFilter.m to run the inversion/particle filtering algorithm

clear all; clc; 
set(0,'DefaultAxesFontSize',14);
set(0,'DefaultLineLineWidth',2);
cmap = get(gca,'ColorOrder');

% paths are defined in this function file. Will need to chage for your computer
definePaths()

% initialize parameters
alpha = 3e9; % scaling from infections to genome copies in wastewater
P = initParams(alpha);
P.START_DATE_PLOT = datetime("2022-01-01");
P.START_DATE = datetime("2021-11-01");
P.norm_idx = days(P.START_DATE_PLOT - P.START_DATE);
P.N_PARTICLES = 1e4; % reduce number of particles so that it runs faster

% load data
tic
[P,CASEDATA,WWDATA] = loadData(P);
toc

% initialize variables
[R,RHO,I,WW,L] = initVar(P,CASEDATA,WWDATA);
TIME = P.START_DATE:P.END_DATE;

% run model
[R,RHO,I,WW,L,TIME,T,ESS] = covidParticleFilter(P,CASEDATA,WWDATA,R,RHO,I,WW,L);

%% plotting

figHand = figure(1); clf;
cidx = 1;

% reproduction number
subplot(3,2,1);
R5 = prctile(R,5);
R50 = prctile(R,50);
R95 = prctile(R,95);

h = line([min(TIME) max(TIME)],[1 1]);
set(h,'Color','k')
hold on;
h = fill([TIME fliplr(TIME)],[R5 fliplr(R95)],cmap(cidx,:));
set(h,'FaceAlpha',0.3)
set(h,'EdgeColor',cmap(cidx,:));
set(h.Parent,'YTick',[0 1 2 3 4 5])
hold on;
plot(TIME,R50,'Color',cmap(cidx,:))
xlim([P.START_DATE P.END_DATE])
vline(P.START_DATE_PLOT)
vline(P.START_DATE+days(P.tIn))
grid on
box on
title('(a) Reproduction Number')

% absolute CAR
ACAR5 = prctile(RHO,5);
ACAR50 = prctile(RHO,50);
ACAR95 = prctile(RHO,95);
subplot(3,2,2);
h = fill([TIME fliplr(TIME)],[ACAR5 fliplr(ACAR95)],cmap(cidx,:));
set(h,'FaceAlpha',0.3)
set(h,'EdgeColor',cmap(cidx,:));
hold on;
plot(TIME,ACAR50,'Color',cmap(cidx,:))
xlim([P.START_DATE P.END_DATE])
vline(P.START_DATE_PLOT)
vline(P.START_DATE+days(P.tIn))
grid on
box on
title('(b) Absolute Case Ascertainment Rate')
ylabel("CAR")

% relative CAR
subplot(3,2,3);
CAR5 = prctile(RHO./RHO(:,P.norm_idx),5);
CAR50 = prctile(RHO./RHO(:,P.norm_idx),50);
CAR95 = prctile(RHO./RHO(:,P.norm_idx),95);
h = fill([TIME fliplr(TIME)],[CAR5 fliplr(CAR95)],cmap(cidx,:));
set(h,'FaceAlpha',0.3)
set(h,'EdgeColor',cmap(cidx,:));
hold on;
plot(TIME,CAR50,'Color',cmap(cidx,:))
xlim([P.START_DATE P.END_DATE])
vline(P.START_DATE_PLOT)
vline(P.START_DATE+days(P.tIn))
grid on
box on
title('(c) Relative Case Ascertainment Rate')
ylabel("CAR relative to " + datestr(P.START_DATE_PLOT));

% infections
subplot(3,2,4);
I5 = prctile(I,5);
I50 = prctile(I,50);
I95 = prctile(I,95);
h = fill([TIME fliplr(TIME)],[I5 fliplr(I95)],cmap(cidx,:));
set(h,'FaceAlpha',0.3)
set(h,'EdgeColor',cmap(cidx,:));
hold on;
plot(TIME,I50,'Color',cmap(cidx,:))
xlim([P.START_DATE P.END_DATE])
vline(P.START_DATE_PLOT)
vline(P.START_DATE+days(P.tIn))
grid on
box on
title('(d) Infections')

% cases
subplot(3,2,5);
R0 = P.kc;
mu = L.*RHO;
P0 = R0./(mu+R0);
preInd = nbinrnd(R0,P0);
L5 = prctile(preInd,5);
L50 = prctile(preInd,50);
L95 = prctile(preInd,95);
h = fill([TIME fliplr(TIME)],[L5 fliplr(L95)],cmap(cidx,:));
set(h,'FaceAlpha',0.3)
set(h,'EdgeColor',cmap(cidx,:));
hold on;
plot(TIME, L50,'Color',cmap(cidx,:))
vline(P.START_DATE_PLOT)
vline(P.START_DATE+days(P.tIn))
grid on
box on
title('(e) Reported Cases')
plot(CASEDATA.DATE,CASEDATA.COUNT,'k--','LineWidth',2);
xlim([P.START_DATE P.END_DATE])

% wastewater
subplot(3,2,6);
a = P.kw;
b = WW/a;
preInd = gamrnd(a,b);
WW5 = prctile(preInd,5);
WW50 = prctile(preInd,50);
WW95 = prctile(preInd,95);
h = fill([TIME fliplr(TIME)],[WW5 fliplr(WW95)],cmap(cidx,:));
set(h,'FaceAlpha',0.3)
set(h,'EdgeColor',cmap(cidx,:));
hold on;
plot(TIME, WW50,'Color',cmap(cidx,:))
vline(P.START_DATE_PLOT)
vline(P.START_DATE+days(P.tIn))
grid on
box on
title('(f) Wastewater Data')
ylabel('Genome copies per day')
plot(WWDATA.DATE,WWDATA.COUNT,'k--','LineWidth',2);
xlim([P.START_DATE P.END_DATE])
