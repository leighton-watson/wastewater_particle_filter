%% Distributions %%
%
% Plot the distributions that are used in the model
% Generation time
% Shedding distribution
% Incubation period
% Reporting lag

clear all; clc;
set(0,'DefaultAxesFontSize',14);
set(0,'DefaultLineLineWidth',2);
cmap = get(gca,'ColorOrder');
figure(1); clf;

% addpath 
addpath ../../model/
definePaths()

%% initialize parameters
alpha = 600; % scaling from infections to genome copies in wastewater - this does not matter for distributions
P = initParams(alpha);

%% plot distributions

figHand = figure(1); clf;

% generation time
figure(1); subplot(2,2,1);
h = bar(1:P.MAX_INF_TIME,P.g);
title('(a) Generation Time');
grid on
ylabel('Likelihood');
xlabel('Time (days) between infections');
xlim([0 10])
set(h.Parent,'XTick',[0:10])

% wastewater shedding
shedTime = [1:P.MAX_SHED_TIME] - 4;
subplot(2,2,2);
bar(shedTime,P.SHED);
title('(b) Wastewater Shedding');
grid on
ylabel('Likelihood');
xlabel('Time (days) since onset of symptoms');

% incubation period
subplot(2,2,3);
bar(0:P.MAX_INC_TIME,P.INC);
grid on
title('(c) Incubation Period');
ylabel('Likelihood');
xlabel('Time (days) from infection to symptom onset');

% reporting delay
subplot(2,2,4);
bar(0:P.MAX_REPORT_LAG,P.REPORT);
title('(d) Reporting Delay');
grid on
ylabel('Likelihood');
xlabel('Time (days) from symptom onset to reporting');


