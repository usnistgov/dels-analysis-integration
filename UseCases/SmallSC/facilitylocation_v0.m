rng(0, 'twister');
facilitycount = 10;
customercount = 1500;
capacity = randi([500, 1500], 1, facilitycount);
X = randi([0, 1000], 1, facilitycount);
Y = randi([0, 1000], 1, facilitycount);
fixedCost = randi([750, 12500], 1, facilitycount);
FacilitySet = [X', Y', capacity', fixedCost'];
X = randi([0, 1000], 1, customercount);
Y = randi([0, 1000], 1, customercount);
CustomerSet = [X', Y'];

Cost = zeros(customercount, facilitycount);

for i = 1:10
    for j = 1:1500
        Cost(j, i) = round( sqrt(abs(FacilitySet(i,1) - CustomerSet(j,1))^2 + abs(FacilitySet(i,2) - CustomerSet(j,2))^2));
    end
end

tic
facility(capacity', fixedCost', Cost);
toc