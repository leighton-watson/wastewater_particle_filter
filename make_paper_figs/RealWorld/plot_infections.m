%% Plot Vary Alpha %%

clear all; clc;
set(0,'DefaultAxesFontSize',14);
set(0,'DefaultLineLineWidth',2);
cmap = get(gca,'ColorOrder');
figHand = figure(1); clf;

ALPHA = [2e9 4e9];

for i = 1:length(ALPHA)
    alpha = ALPHA(i);
    filename = "alpha" + num2str(alpha) + ".mat";
    load(filename)
    cidx = i;
    
    figure(1);
        
    % infections
    subplot(3,1,1);
    h = fill([TIME fliplr(TIME)],[I5 fliplr(I95)],cmap(cidx,:));
    set(h,'FaceAlpha',0.3)
    set(h,'EdgeColor',cmap(cidx,:));
    hold on;
    plot(TIME,I50,'Color',cmap(cidx,:))
    xlim([P.START_DATE_PLOT P.END_DATE])
    grid on
    box on
    title('(a) Infections')
        
    % cumulative infections
    subplot(3,1,2);
    h = fill([TIME fliplr(TIME)],[CI5 fliplr(CI95)],cmap(cidx,:));
    set(h,'FaceAlpha',0.3)
    set(h,'EdgeColor',cmap(cidx,:));
    hold on;
    plot(TIME,CI50,'Color',cmap(cidx,:))
    xlim([P.START_DATE_PLOT P.END_DATE])
    grid on
    box on
    title('(b) Cumulative Infections')
    h = hline(5151600);
    set(h,'Color','k');
        
    % absolute CAR
    subplot(3,1,3);
    h = fill([TIME fliplr(TIME)],[ACAR5 fliplr(ACAR95)],cmap(cidx,:));
    set(h,'FaceAlpha',0.3)
    set(h,'EdgeColor',cmap(cidx,:));
    hold on;
    plot(TIME,ACAR50,'Color',cmap(cidx,:))
    xlim([P.START_DATE_PLOT P.END_DATE])
    grid on
    box on
    title('(c) Case Ascertainment Rate')
    ylim([0 1])
    
    % calculate mean absolute CAR between two dates
    t1 = datetime("2022-02-01");
    t2 = datetime("2022-07-01");
    idx1 = find(TIME>=t1,1,'first');
    idx2 = find(TIME>=t2,1,'first');
    
    mean_car5(i) = mean(ACAR5(idx1:idx2));
    mean_car50(i) = mean(ACAR50(idx1:idx2));
    mean_car95(i) = mean(ACAR95(idx1:idx2));

   
    
end

% plot case data
figure(1);
subplot(3,1,1);
plot(CASEDATA.DATE,CASEDATA.COUNT,'k');

subplot(3,1,2);
plot(CASEDATA.DATE,cumsum(CASEDATA.COUNT),'k');