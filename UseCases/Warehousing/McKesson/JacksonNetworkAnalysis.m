nProcess = 4;
arrivalRate = 1/2.7;

%Make arrival rate at center k
lambda = zeros(1,nProcess);

lambda(1) = arrivalRate;

%Make service rate
S = [3.5 13 6 5];

%Set Number of machines at each workstation
m = [3 54 4 1];

%Prob transition matrix
%[Label Spur Bagger Depuck]
P = [[0 1 0 0 ]; [0 0 0.8739 0.1261]; [0 0 0 0]; [0 0 0 0]];

try
    V = qnosvisits(P,lambda);
    [Util, ServiceTime, AvgNoRequests, Th] = qnopen(sum(lambda), S, V, m);
catch err
    rethrow(err)
end

%% Complex Model
%To get the data from Excel to Matlab
% 1) P = zeros(65); copy the Prob matrix from excel then open P in matlab,
% right click in first cell of array and 'paste excel data'
% then P = P(1:64, 1:64); (don't need inflow/outflow nodes)
% 2) ProcessData = cell(64, 3); copy the process
% name/machinecount/processtime from excel; then
% right click in first cell of array and 'paste excel data'
% I saved the variables in the folder, so we don't need to do this in the
% future
nProcess = 64;
arrivalRate = 1/2.7;


%Make arrival rate at center k
lambda = zeros(1,nProcess);
lambda(1:2) = arrivalRate.*[0.8, 0.2];

load('complexProbMatrix');
load('complexProcessData');
machineCount = cell2mat(processData(:,2))';
processTime = cell2mat(processData(:,3))';

try
    V = qnosvisits(P,lambda);
    [Util, ServiceTime, AvgNoRequests, Th] = qnopen(sum(lambda), processTime, V, machineCount);
catch err
    rethrow(err)
end


[Y, I] = max(Util)
processData(I,1)

%if you set the arrival rate too high, you get this error:
% Error using qnos (line 112)
% Processing capacity exceeded at center 62
