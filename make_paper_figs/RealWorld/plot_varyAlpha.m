%% Plot Vary Alpha %%

clear all; clc;
set(0,'DefaultAxesFontSize',14);
set(0,'DefaultLineLineWidth',2);
cmap = get(gca,'ColorOrder');
figHand = figure(1); clf;

ALPHA = [2e9 3e9 4e9];

for i = 1:length(ALPHA)
    alpha = ALPHA(i);
    filename = "alpha" + num2str(alpha) + ".mat";
    load(filename)
    cidx = i;
    
    figure(1);
        
    % reproduction number
    subplot(3,1,1);
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
    
    % absolute CAR
    subplot(3,1,2);
    h = fill([TIME fliplr(TIME)],[ACAR5 fliplr(ACAR95)],cmap(cidx,:));
    set(h,'FaceAlpha',0.3)
    set(h,'EdgeColor',cmap(cidx,:));
    hold on;
    plot(TIME,ACAR50,'Color',cmap(cidx,:))
    xlim([P.START_DATE_PLOT P.END_DATE])
    grid on
    box on
    title('(b) Absolute Case Ascertainment Rate')
    ylabel("CAR");
    ylim([0 1]);
    
    % relative CAR
    subplot(3,1,3);
    h = fill([TIME fliplr(TIME)],[CAR5 fliplr(CAR95)],cmap(cidx,:));
    set(h,'FaceAlpha',0.3)
    set(h,'EdgeColor',cmap(cidx,:));
    hold on;
    plot(TIME,CAR50,'Color',cmap(cidx,:))
    xlim([P.START_DATE_PLOT P.END_DATE])
    grid on
    box on
    title('(c) Relative Case Ascertainment Rate')
    ylabel("CAR relative to " + datestr(P.START_DATE_PLOT));
    
    
    
end