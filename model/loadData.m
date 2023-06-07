function [P,CASES,WW,ww_raw,ww_intp] = loadData(P)

%%% cases
% from https://github.com/minhealthnz/nz-covid-data

% load date column
tmp = readmatrix('covid-case-counts.csv','OutputType','datetime'); % load time
Date = tmp(:,1);

% load case column
tmp = readmatrix('covid-case-counts.csv');
Cases = tmp(:,8);

T = table(Date,Cases); % make table
G = groupsummary(T,"Date","Sum"); % group over same day

% truncate entries before start date
idx = find(G.Date>=P.START_DATE,1,'first');
CASES = [];
CASES.DATE = G.Date(idx:end); % date
CASES.RAW_COUNT = G.sum_Cases(idx:end); % raw counts
CASES.COUNT = movmean(CASES.RAW_COUNT,7); % 7 day moving average
CASES.T = [1:length(CASES.DATE)]'; % time index

%%% wastewater data
% from https://github.com/ESR-NZ/covid_in_wastewater

% load date column
tmp = readmatrix('ww_national.csv','OutputType','datetime'); % load time
tshift = 4; % shift datetime by four days to go from Sunday to Wednesday
ww_raw.date = tmp(:,1) - caldays(tshift); % date
ww_raw.t = datenum(ww_raw.date) - datenum(ww_raw.date(1));  % time index starting at 1 for first entry

% load data
tmp = readmatrix('ww_national.csv'); % load data
ww_raw.d = tmp(:,3); % genome copies per person per day
ww_raw.pop = tmp(:,2); % population covered by wastewater testing

% interpolate from seven day average to daily
ww_intp.t = [ww_raw.t(1):ww_raw.t(end)]';
ww_intp.d = pchip(ww_raw.t,ww_raw.d,ww_intp.t);
ww_intp.pop = pchip(ww_raw.t,ww_raw.pop,ww_intp.t);
ww_intp.date = ww_raw.date(1) + days(ww_intp.t);

% truncate entries before start date 
idx = find(ww_intp.date>=P.START_DATE,1,'first');
WW = [];
WW.DATE = ww_intp.date(idx:end); % date
WW.COUNT = ww_intp.d(idx:end); % genome copies per person per day
WW.POP = ww_intp.pop(idx:end); % population covered by wastewater testing
WW.T = [1:length(WW.DATE)]'; % time index

% find end time
P.TMAX = min([max(CASES.T),max(WW.T)]);
P.END_DATE = CASES.DATE(P.TMAX);
