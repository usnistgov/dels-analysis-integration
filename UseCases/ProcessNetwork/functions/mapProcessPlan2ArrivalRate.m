function lambda = mapProcessPlan2ArrivalRate(processPlanSet, productArrivalRate)
%mapProcessPlan2ArrivalRate maps the process plan and product arrival rate to the arrival rate to each
%service center

    %Make arrival rate at center k
    [nProd, ~] = size(processPlanSet);
    nProcess = max(max(processPlanSet));
    lambda = zeros(1,nProcess);
    for ii = 1:nProd
        lambda(processPlanSet(ii,1)) = lambda(processPlanSet(ii,1))+ productArrivalRate(ii);
    end

end

