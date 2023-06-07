function P = initParams(alpha)
% function P = initParams()
% initialize parameters with default values

% weighting of particle filter on cases (C), wastewater (W), or cases +
% wastewater (CW)
P.WEIGHT = 'CW';

% scaling from infections to wastewater data
P.alpha = alpha;

% length of particle filter
P.L = 30; 

% maximum time
P.TMAX = nan;

% variance on random walks
P.SIGMA_R = 0.1; % How variable is the random walk on Rt?
P.SIGMA_RHO = 0.01; % random walk on RHO (case ascertainment rate)

% variance on observation filtering distributions
P.kc = 100; % negative binomial for cases
P.kw = 10; % gamma distribution for wastewater

% wind in time
P.tIn = 30; % length of wind-in

% New Zealand population size
P.POP = 5151600;

% generation time
P.MAX_INF_TIME = 30; % After 30 days the generation time distribution is basically 0. It also makes sense to set this to be = to L I think?
% from Vattiatio et al. (2022) Epidemics Modelling the dynamics of infection, 
% waning of immunity and re-infection with the Omicron variant of SARS-CoV-2 in Aotearoa New Zealand
% https://doi.org/10.1016/j.epidem.2022.100657
gam_m = 3.3; % mean of gamma distribution
gam_sd = 1.3; % standard deviation of gamma distribution
gam_shape = gam_m^2/gam_sd^2;
gam_scale = gam_sd^2/gam_m;
P.g = diff(gamcdf(0:P.MAX_INF_TIME, gam_shape, gam_scale));

% wastewater shedding
% from Hewitt et al. (2022) Sensitivity of
% wastewater-based epidemiology for detection of SARS-CoV-2 RNA in a
% low prevalence setP.tIng, Water Research,
% https://doi.org/10.1016/j.watres.2021.118032
shedding = load('ww_shedding.csv'); % this is relative to symptom onset. Assume infection is 3 days prior to symptom onset
shedding_norm = shedding(:,2)'/sum(shedding(:,2)); % normalize so that area under the curve is one
P.SHED = shedding_norm;
P.MAX_SHED_TIME = length(P.SHED);

% lag between symptom onset and reporpting as a case based on NZ data from epiSurv
reporting = load('OnsetReportDistribution_Truncated.csv');
reporting_norm = reporting(:,2)'/sum(reporting(:,2));
P.REPORT = reporting_norm;
P.MAX_REPORT_LAG = max(reporting(:,1));

% incubation lag between infection and onset of symptoms taken from
% Jantien A. Backer et al. Shorter Serial Intervals in SARS-CoV-2 Cases with Omicron BA.1 Variant
% Compared with Delta Variant, the Netherlands, 13 to 26 December 2021?. In: Eurosurveillance 27.6
% (Feb. 10, 2022), p. 2200042. issn: 1560-7917. doi: 10.2807/1560- 7917
scale = 3.2;
shape = 1.5;
t_incubation = 0:1:10;
incubation = wblpdf(t_incubation,scale,shape);
P.INC = incubation./sum(incubation);
P.MAX_INC_TIME = max(t_incubation);

% combine reporP.tIng and incubation lag and re-normalize
P.IR_LAG_UNNORM = conv(P.INC,P.REPORT);
P.IR_LAG = P.IR_LAG_UNNORM./sum(P.IR_LAG_UNNORM);
P.IR_LAG_MAX_TIME = length(P.IR_LAG);

% combine wastewater shedding and incubation lag, truncate, and
% re-normalize
P.ISHED_UNNORM = conv(P.INC,P.SHED);
P.ISHED_TRUNC = P.ISHED_UNNORM(4:end);
P.ISHED = P.ISHED_TRUNC./sum(P.ISHED_TRUNC);
P.MAX_ISHED_TIME = length(P.ISHED);