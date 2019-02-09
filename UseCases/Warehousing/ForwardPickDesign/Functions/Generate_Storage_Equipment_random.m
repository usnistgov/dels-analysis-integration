seqSet(10) = Storage_Equipment;

for se = 1:10
    
    seqSet(se).ID = se;
    seqSet(se).storage_height = unidrnd(5);
    seqSet(se).bay_width = 3.33;
    seqSet(se).bay_length = 4;
    seqSet(se).bay_height = 4;
    seqSet(se).cost = 1000;
    
end

seqSet = seqSet.sort;