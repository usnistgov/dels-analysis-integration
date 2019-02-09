peqSet(10) = Pick_Equipment;

for pe = 1:10
    
    peqSet(pe).ID = pe;
    peqSet(pe).reachable_height = unidrnd(5);
    peqSet(pe).req_aisle_width = unifrnd(5,10);
    peqSet(pe).capacity = unidrnd(10);
    peqSet(pe).vertical_velocity = unifrnd(55,70)/60;
    peqSet(pe).vertical_acc = 6;
    peqSet(pe).horizontal_velocity = unifrnd(200,600)/60;
    peqSet(pe).horizontal_acc = 10;
    peqSet(pe).cost = 1000;
    
end

peqSet = peqSet.sort;