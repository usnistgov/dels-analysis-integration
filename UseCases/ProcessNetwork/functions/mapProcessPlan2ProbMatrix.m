function [ P ] = mapProcessPlan2ProbMatrix( processPlanSet, productArrivalRate )
%mapProcessPlan2ProbMatrix - Map the process plan and product arrival rate to the probability
%transition matrix


[nProd, lengthProcessPlan] = size(processPlanSet);
nProcess = max(max(processPlanSet));
P = zeros(nProcess);

% Add Arrival & Flow Rates to Prob Matrix
for ii = 1:nProd
   for jj = 1:lengthProcessPlan-1
       P(processPlanSet(ii,jj), processPlanSet(ii,jj+1)) = productArrivalRate(ii);
   end
end

%Make Prob Matrix Stochastic (including outflow)
%Add the outflow rate to the rowSum; rows don't add up to 1
rowSum = sum(P,2);
for ii = 1:nProcess
    if rowSum(ii) > 0
        P(ii,:) = P(ii,:)./(rowSum(ii) + (processPlanSet(:, end) == ii)'*productArrivalRate);
    end
end
end

