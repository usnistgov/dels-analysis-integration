
function [meanTotalCost, varTotalCost, meanServiceLevel, varServiceLevel ] = sSCont(x, runlength, seed, ~)
% x is the (s, S) vector; (r, r+Q) for (Q,r); (r, r+1) for Base Stock, (0,EOQ) for EOQ, (Q*, Q*+1) for newsvendor
% runlength is the number of days of demand to simulate
% seed is the index of the substreams to use (integer >= 1)
% other is not used
%runlength must be greater than warmup period 


FnGrad = NaN;
FnGradCov = NaN;    
ConstraintGrad = NaN;
ConstraintGradCov = NaN;

if (sum(x < 0)> 0 )|| (runlength <= 0) || (runlength ~= round(runlength)) || (seed <= 0) || (round(seed) ~= seed)
    fprintf('x should be >= 0, runlength should be positive integer, seed must be a positive integer\n');
    fn = NaN;
    FnVar = NaN;
    constraint = NaN;
	ConstraintCov = NaN;
elseif (x(1)>=x(2))
    fprintf('S must be greater than s\n');
    fn = NaN;
    FnVar = NaN;
    constraint = NaN;
    ConstraintCov = NaN;

else
%%%%%%%%%%%%%%%%PARAMETERS%%%%%%%%%%%%%%%%%%
nRepetitions = 10;                %Repetitions
meanDemand = 4;                  %Mean demand
stdevDemand = 1;                 %Standard deviation of demand; set to 0 for constant
meanLT = 7;                      %Mean lead time
stdevLT = 1.5;                   %Standard deviation of lead time; set to 0 for constant
fixed = 15;                      %Fixed order cost
varC = 2;                        %Variable, per unit, cost
holding = 0.1*varC;              %Holding cost
initialInvOH = x(1);             %Initial Inventory On Hand
stockout = 1;                    %Stockout cost := one time cost if cannot satisfy from stock
backorder = 1;                   %Backorder cost := recurring cost each time period demand goes unsatisfied
I_CarryOver = 1;                 %Indicator: Inventory allowed to carry over period to period
warmup = 10;                     %length of warm up period
nDays = runlength+warmup;        %Length of simulation: 10050

%%%%%%%%Decision Variables%%%%%%%%%
s=x(1);
S=x(2);

    % Generate new streams for 
    [DemandStream, LeadTimeStream] = RandStream.create('mrg32k3a', 'NumStreams', 2);

    % Set the substream to the "seed"
    DemandStream.Substream = seed;
    LeadTimeStream.Substream = seed;

    % Generate demands
    OldStream = RandStream.setGlobalStream(DemandStream);
    %Dem=round(normrnd(meanDemand,stdevDemand, nRepetitions, nDays));
    %Dem = round(exprnd(meanDemand,nRepetitions,nDays));
    Dem = (rand(nRepetitions,nDays)>(1-meanDemand/meanLT)); %(Q,r) Model: demands arrive one at a time
    
    % Generate lead times
    RandStream.setGlobalStream(LeadTimeStream);
    LT=poissrnd(meanLT, nRepetitions, nDays);
    %LT=round(normrnd(meanLT,stdevLT, nRepetitions, nDays));
    
    RandStream.setGlobalStream(OldStream); % Restore previous stream

Output = zeros(2,nRepetitions);
Inv = zeros(nRepetitions, nDays);
InvPos = zeros(nRepetitions, nDays);
for j =1:nRepetitions

    %Vector tracks outstanding orders. Row 1: day of delivery and row 2: quantity.
    Orders = zeros(2,1);
    InvOH = initialInvOH;
    IP = initialInvOH;
    %Variables to estimate service level constraint.
    nUnits = 0;
    nLate = 0;

    TotalCost = 0;
    
    for i=1:nDays
        Inv(j,i) = InvOH; 
        InvPos(j,i) = IP;
        
        %Receive orders
        if length(Orders(1,:)) > 1
            [C,I] = min(Orders(1,2:length(Orders(1,:))));
            while( C == i)
                InvOH = InvOH + Orders(2,I+1);
                Orders(:,I+1) = [];
                C = 0;
                I = 0;
                if length(Orders(1,:)) > 1
                    [C,I] = min(Orders(1,2:length(Orders(1,:))));
                end
            end
        end
        

        %Satisfy or backorder demand
        Demand = Dem(j,i);
        InvOH = InvOH - Demand;
        if(i > warmup)
            nUnits = nUnits + Demand;
            if InvOH < 0
                nLate = nLate + min(Demand, -InvOH);
            end
        end
        
        
        %Calculate Inventory Position and place orders.
        InvOH = InvOH*I_CarryOver;
        IP = InvOH + sum(Orders(2,:));
        if( IP <= s )
            leadTime = LT(j,i);
            x = S-IP;
            %x = Demand;
            Orders = [Orders, [i+leadTime+1; x]];
            if ( i > warmup)
                TotalCost= TotalCost + fixed + x*varC;
            end
            
            IP = InvOH + sum(Orders(2,:));
        end
        
        if ( i > warmup)
            TotalCost = TotalCost + holding*max(InvOH, 0)+backorder*max(-InvOH,0);
        end           
    end

Output(1,j) = TotalCost;%/(nDays-warmup);
Output(2,j) = 1+sum(Inv(j, Inv(j,:)<0))/nUnits;


end

%Optional Space for 'Plots On'
plot([1:nDays], Inv(1,:), [1:nDays], InvPos(1,:))



%First row has mean cost, second has stockout rate:
meanTotalCost = mean(Output(1,:));
varTotalCost = var(Output(1,:))/nRepetitions;
meanServiceLevel = mean(Output(2,:)); % Constraint not satisfied if this is positive
varServiceLevel = var(Output(2,:))/nRepetitions;

end
end

