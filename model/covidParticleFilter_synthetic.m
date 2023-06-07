function [R,RHO,I,WW,L,T,ESS] = covidParticleFilter_synthetic(P,CASEDATA,WWDATA,R,RHO,I,WW,L)
% function [R,RHO,I,WW,L,T,ESS] = covidParticleFilter_synthetic(P,cases,ww,R,RHO,I,WW,L)
% run particle filter to estimate reproduction number and case
% ascertainment rate from case and wastewater data
ESS = zeros(P.TMAX,1);

for tt = P.tIn + 1 : P.TMAX
    disp(tt)

    % Calculate infection pressure of particles
    dailyInfPressure = I(:,tt-1:-1:max(1, tt-P.MAX_INF_TIME)) .* P.g(1:1:min(tt-1, P.MAX_INF_TIME));
    Lam = sum(dailyInfPressure,2);

    % apply incubation period and reporting delay lag to infections
    dailyZ = I(:,tt-1:-1:max([1,tt-P.IR_LAG_MAX_TIME])) .* P.IR_LAG(1:1:min([tt-1, P.IR_LAG_MAX_TIME]));
    Z = sum(dailyZ,2);
    L(:,tt) = Z;

    % Calculate shedding of infections
    dailyShedding = I(:,tt-1:-1:max(1, tt-P.MAX_ISHED_TIME)) .* P.ISHED(1:1:min(tt-1, P.MAX_ISHED_TIME)) .* P.alpha; % update genome copies
    WW(:,tt) = sum(dailyShedding,2); % genome copies

    % Run projection step
    R(:,tt) = R(:,tt-1) + ((P.SIGMA_R * R(:,tt-1)) .* randn(P.N_PARTICLES, 1)); % random walk for reproduction number
    R(R(:,tt)<=0,tt) = 0.0001; % Set any negative R values to very near zero but positive. This is a bandaid for the fact I cannot figure out how to efficiently sample from a truncated normal dist in MATLAB.
    I(:,tt) = poissrnd(Lam .* R(:,tt)); % update infections

    RHO(:,tt) = RHO(:,tt-1) + (P.SIGMA_RHO .* randn(P.N_PARTICLES, 1)); % update case ascertainment rate
    RHO(RHO(:,tt)<=0,tt) = 0.0001;
    RHO(RHO(:,tt)>=1,tt) = 0.9999;


    % Run filtering step
    R0 = P.kc;
    mu = round(Z).*RHO(:,tt);
    P0 = P.kc./(mu+P.kc);
    W_cases = nbinpdf(round(CASEDATA.COUNT(tt)), R0, P0); % negative binomial model for filtering step for cases
    W_ww = gampdf(WWDATA.COUNT(tt), P.kw, WW(:,tt)/P.kw); % filtering step for wastewater

    % weighting on cases, wastewater, or both
    if strcmp(P.WEIGHT,'C')
        W = W_cases;
    elseif strcmp(P.WEIGHT,'W')
        W = W_ww;
    elseif strcmp(P.WEIGHT,'CW')
        W = W_cases .* W_ww;
    else
        error('Incorrect P.WEIGHT specification. Choose from ''C'', ''W'', or ''CW''');
    end
    ESS(tt) = (sum(W).^2)./sum(W.^2); % track weights/number of particles through time

    % Resample according to W
    resample_indices = randsample(1:P.N_PARTICLES, P.N_PARTICLES, true, W);
    resample_starttime = max(1, tt-P.L);

    R(:,resample_starttime:tt) = R(resample_indices,resample_starttime:tt);
    RHO(:,resample_starttime:tt) = RHO(resample_indices,resample_starttime:tt);
    I(:,resample_starttime:tt) = I(resample_indices,resample_starttime:tt);
    WW(:,resample_starttime:tt) = WW(resample_indices,resample_starttime:tt);
    L(:,resample_starttime:tt) = L(resample_indices,resample_starttime:tt);

end

% format outputs for plotting
T = 1:tt;

end



