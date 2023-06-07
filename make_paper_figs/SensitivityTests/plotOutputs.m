%% Plot Vary Alpha %%

clear all; clc;
set(0,'DefaultAxesFontSize',14);
set(0,'DefaultLineLineWidth',2);
cmap = get(gca,'ColorOrder');
figHand = figure(1); clf;

param_num = 1:3;
param_name = "kw_";

for i = 1:length(param_num)
    
    filename = param_name + num2str(param_num(i)) + ".mat";
    load(filename)
    cidx = i;
    
    figure(1);
    P.kw
        
    % reproduction number
    subplot(3,2,1);
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
    ylim([0 4])
    
    % infections
    subplot(3,2,2);
    h = fill([TIME fliplr(TIME)],[I5 fliplr(I95)],cmap(cidx,:));
    set(h,'FaceAlpha',0.3)
    set(h,'EdgeColor',cmap(cidx,:));
    %set(h.Parent,'YScale','log')
    hold on;
    plot(TIME,I50,'Color',cmap(cidx,:))
    xlim([P.START_DATE_PLOT P.END_DATE])
    grid on
    box on
    title('(b) Infections')
    ylim([0 8e4])
        
    % absolute CAR
    subplot(3,2,3);
    h = fill([TIME fliplr(TIME)],[ACAR5 fliplr(ACAR95)],cmap(cidx,:));
    set(h,'FaceAlpha',0.3)
    set(h,'EdgeColor',cmap(cidx,:));
    hold on;
    plot(TIME,ACAR50,'Color',cmap(cidx,:))
    xlim([P.START_DATE_PLOT P.END_DATE])
    grid on
    box on
    title('(c) Absolute Case Ascertainment Rate')
    ylabel("CAR");
    ylim([0 1]);
    
    % relative CAR
    subplot(3,2,4);
    h = fill([TIME fliplr(TIME)],[CAR5 fliplr(CAR95)],cmap(cidx,:));
    set(h,'FaceAlpha',0.3)
    set(h,'EdgeColor',cmap(cidx,:));
    hold on;
    plot(TIME,CAR50,'Color',cmap(cidx,:))
    xlim([P.START_DATE_PLOT P.END_DATE])
    grid on
    box on
    title('(d) Relative Case Ascertainment Rate')
    ylabel("CAR relative to " + datestr(P.START_DATE_PLOT));
    ylim([0 2.5]);
    
    % cases
    subplot(3,2,5);
    h = fill([TIME fliplr(TIME)],[L5 fliplr(L95)],cmap(cidx,:));
    set(h,'FaceAlpha',0.3)
    set(h,'EdgeColor',cmap(cidx,:));
    %set(h.Parent,'YScale','log')
    hold on;
    plot(TIME,L50,'Color',cmap(cidx,:))
    xlim([P.START_DATE_PLOT P.END_DATE])
    grid on
    box on
    title('(e) Cases')
    plot(CASEDATA.DATE,CASEDATA.COUNT,'k:');
    ylim([0 4e4])
    
    % wastewater
    subplot(3,2,6);
    h = fill([TIME fliplr(TIME)],[WW5 fliplr(WW95)],cmap(cidx,:));
    set(h,'FaceAlpha',0.3)
    set(h,'EdgeColor',cmap(cidx,:));
    %set(h.Parent,'YScale','log')
    hold on;
    plot(TIME,WW50,'Color',cmap(cidx,:))
    xlim([P.START_DATE_PLOT P.END_DATE])
    grid on
    box on
    title('(f) Wastewater Data')
    ylabel('gc/p/d');
    plot(WWDATA.DATE,WWDATA.COUNT,'k:');
    ylim([0 5e7])
    
    
    
end