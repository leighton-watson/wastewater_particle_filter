%% PLot Data %%

clear all; clc;
set(0,'DefaultAxesFontSize',14);
set(0,'DefaultLineLineWidth',2);
cmap = get(gca,'ColorOrder');

% addpath 
addpath ../../model/
definePaths()

%% Load Data %%

P.START_DATE = datetime("2022-01-01");
P.TMAX = nan;
[P,CASES,WW,ww_raw] = loadData(P);
P.TMAX = min([max(CASES.T),max(WW.T)]);
nz_pop = 5151600;

%% Plotting %%

figHand = figure(1); clf;
msize = 10;
xtick = P.START_DATE + calmonths(0:24);

% cases
subplot(2,1,1);
h = bar(CASES.DATE,CASES.RAW_COUNT,'FaceColor',cmap(2,:));
set(h,'FaceAlpha',0.6)
set(h.Parent,'XTick',xtick)
xlim([P.START_DATE,P.END_DATE]);
grid on;
title('(a) Reported Cases');
hold on;
plot(CASES.DATE,CASES.COUNT,'Color',cmap(1,:));

% wastewater
subplot(2,1,2);
yyaxis left
h = plot(WW.DATE,WW.COUNT);
set(h.Parent,'XTick',xtick)
hold on;
plot(ww_raw.date,ww_raw.d,'o','MarkerSize',8,'MarkerFaceColor',cmap(1,:),'MarkerEdgeColor',cmap(1,:))
xlim([P.START_DATE,P.END_DATE]);
ylabel('GC/person/day')
grid on
title('(b) Wastewater Data');
yyaxis right
plot(WW.DATE,WW.POP./nz_pop*100,'-','Color',cmap(2,:));
hold on
plot(ww_raw.date,ww_raw.pop./nz_pop*100,'o','MarkerSize',8,'MarkerFaceColor',cmap(2,:),'MarkerEdgeColor',cmap(2,:))
ylabel('Population covered (%)')
ylim([0 100])




