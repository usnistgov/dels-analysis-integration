nProducts = 8;
ProductSet(nProducts) = Product;

for ii = 1:length(ProductSet)
   ProductSet(ii).ID = ii;
   ProductSet(ii).meanDemand = round((500-100)*rand + 100);
   ProductSet(ii).stdevDemand = 0.1*ProductSet(ii).meanDemand;
end

nRenewableResources = 17;
RenewableResourceSet(nRenewableResources) = Resource;

for ii = 1:length(RenewableResourceSet)
    RenewableResourceSet(ii).ID = ii;
    RenewableResourceSet(ii).variableCost = round((75-50)*rand + 50); 
end

nConsumableResources = 30;
ConsumableResourceSet(nConsumableResources) = Resource;

for ii = 1:length(ConsumableResourceSet)
    ConsumableResourceSet(ii).ID = ii;
    ConsumableResourceSet(ii).variableCost = round((25-10)*rand + 10); 
end

nProcesses = 45;
ProcessSet(nProcesses) = Process;
Produces = randsample(nProducts,nProcesses, true);

for ii = 1:nProcesses
   ProcessSet(ii).ID = ii;
   ProcessSet(ii).Revenue = round((12500-7500)*rand + 7500);
   ProcessSet(ii).Produces(end+1) = ProductSet(Produces(ii));
   ProcessSet(ii).Produces.canBeCreatedBy(end+1)= ProcessSet(ii);
   ProcessSet(ii).RenewableResourceSet = RenewableResourceSet(randsample(length(RenewableResourceSet), 5));
   ProcessSet(ii).RenewableResourceCapReq = (1.5-1)*rand(1, length(ProcessSet(ii).RenewableResourceSet)) +1;
   ProcessSet(ii).ConsumableResourceSet = ConsumableResourceSet(randsample(length(ConsumableResourceSet), 5));
   ProcessSet(ii).ConsumableResourceCapReq = round((4-0)*rand(1, length(ProcessSet(ii).ConsumableResourceSet)) +0);
end

