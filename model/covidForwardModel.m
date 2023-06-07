function [I,WW,L,T] = covidForwardModel(P,R,I,WW,L)
% function [I,WW,L,T] = covidForwardModel(P,R,I,WW,L)
% run model forwards without particle filtering to determine case and
% wastewater data for prescribed reproduction number and case ascertainment

for tt = P.tIn + 1 : P.TMAX
    disp(tt)

    % Calculate infection pressure of particles
    dailyInfPressure = I(:,tt-1:-1:max(1, tt-P.MAX_INF_TIME)) .* P.g(1:1:min(tt-1, P.MAX_INF_TIME));
    Lam = sum(dailyInfPressure,2);
    I(:,tt) = poissrnd(Lam .* R(tt)); % update infections

    % apply incubation period and reporting delay lag to infections
    dailyZ = I(:,tt-1:-1:max([1,tt-P.IR_LAG_MAX_TIME])) .* P.IR_LAG(1:1:min([tt-1, P.IR_LAG_MAX_TIME]));
    Z = sum(dailyZ,2);
    L(:,tt) = Z;

    % Calculate shedding of infections
    dailyShedding = I(:,tt-1:-1:max(1, tt-P.MAX_ISHED_TIME)) .* P.ISHED(1:1:min(tt-1, P.MAX_ISHED_TIME)) .* P.alpha; % update genome copies
    WW(:,tt) = sum(dailyShedding,2); % genome copies

end

% format outputs for plotting
T = 1:tt;

end



