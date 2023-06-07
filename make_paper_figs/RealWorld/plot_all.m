clear all; clc;
set(0,'DefaultAxesFontSize',14);
set(0,'DefaultLineLineWidth',2);
cmap = get(gca,'ColorOrder');
figHand = figure(1); clf;
set(figHand,'Position',[100 100 1400 1100])

alpha = 3e9;
filename = "alpha" + num2str(alpha) + ".mat";
load(filename)

figure(1);
cidx = 1;

% reproduction number
subplot(2,2,1);
h = fill([TIME fliplr(TIME)],[R5 fliplr(R95)],cmap(cidx,:));
set(h,'FaceAlpha',0.3)
set(h,'EdgeColor',cmap(cidx,:));
hold on;
plot(TIME,R50,'Color',cmap(cidx,:))
xlim([P.START_DATE_PLOT P.END_DATE])
grid on
box on
title('(a) Reproduction Number')
ylabel('R Number')

% relative CAR
subplot(2,2,2);
h = fill([TIME fliplr(TIME)],[CAR5 fliplr(CAR95)],cmap(cidx,:));
set(h,'FaceAlpha',0.3)
set(h,'EdgeColor',cmap(cidx,:));
hold on;
plot(TIME,CAR50,'Color',cmap(cidx,:))
xlim([P.START_DATE_PLOT P.END_DATE])
grid on
box on
title('(b) Relative Case Ascertainment Rate')
ylabel("CAR relative to " + datestr(P.START_DATE_PLOT));

% reported cases
subplot(2,2,3);
h = fill([TIME fliplr(TIME)],[L5 fliplr(L95)],cmap(cidx,:));
set(h,'FaceAlpha',0.3)
set(h,'EdgeColor',cmap(cidx,:));
hold on;
plot(TIME, L50,'Color',cmap(cidx,:))
xlim([P.START_DATE_PLOT P.END_DATE])
grid on
box on
title('(c) Reported Cases')
plot(CASEDATA.DATE,CASEDATA.COUNT,'k:','LineWidth',2);

% wastewater
subplot(2,2,4);

h = fill([TIME fliplr(TIME)],[WW5 fliplr(WW95)],cmap(cidx,:));
set(h,'FaceAlpha',0.3)
set(h,'EdgeColor',cmap(cidx,:));
hold on;
plot(TIME, WW50,'Color',cmap(cidx,:))
xlim([P.START_DATE_PLOT P.END_DATE])
grid on
box on
title('(d) Wastewater Data')
ylabel('gc/p/d')
plot(WWDATA.DATE,WWDATA.COUNT,'k:','LineWidth',2);


% absolute CAR
figure(2); clf;
h = fill([TIME fliplr(TIME)],[ACAR5 fliplr(ACAR95)],cmap(cidx,:));
set(h,'FaceAlpha',0.3)
set(h,'EdgeColor',cmap(cidx,:));
hold on;
plot(TIME,ACAR50,'Color',cmap(cidx,:))
xlim([P.START_DATE_PLOT P.END_DATE])
grid on
box on

ylabel("CAR relative to " + datestr(P.START_DATE_PLOT));