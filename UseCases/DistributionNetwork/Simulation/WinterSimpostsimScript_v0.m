Customer_1_arrivals = [Customer_1.time, Customer_1.signals.values];
Customer_1_summary = zeros(5,2);

for i = 1:5
    Customer_1_summary(i,1) = mean(Customer_1_arrivals(Customer_1_arrivals(:,2) == i,1) - Customer_1_arrivals(Customer_1_arrivals(:,2) == i,4));
    Customer_1_summary(i,2) = std(Customer_1_arrivals(Customer_1_arrivals(:,2) == i,1) - Customer_1_arrivals(Customer_1_arrivals(:,2) == i,4));
end

Customer_1_summary

Customer_2_arrivals = [Customer_2.time, Customer_2.signals.values];
Customer_2_summary = zeros(5,2);

for i = 1:5
    Customer_2_summary(i,1) = mean(Customer_2_arrivals(Customer_2_arrivals(:,2) == i,1) - Customer_2_arrivals(Customer_2_arrivals(:,2) == i,4));
    Customer_2_summary(i,2) = std(Customer_2_arrivals(Customer_2_arrivals(:,2) == i,1) - Customer_2_arrivals(Customer_2_arrivals(:,2) == i,4));
end

Customer_2_summary

Customer_3_arrivals = [Customer_3.time, Customer_3.signals.values];
Customer_3_summary = zeros(5,2);


for i = 1:5
    Customer_3_summary(i,1) = mean(Customer_3_arrivals(Customer_3_arrivals(:,2) == i,1) - Customer_3_arrivals(Customer_3_arrivals(:,2) == i,4));
    Customer_3_summary(i,2) = std(Customer_3_arrivals(Customer_3_arrivals(:,2) == i,1) - Customer_3_arrivals(Customer_3_arrivals(:,2) == i,4));
end

Customer_3_summary

Customer_4_arrivals = [Customer_4.time, Customer_4.signals.values];
Customer_4_summary = zeros(5,2);

for i = 1:5
    Customer_4_summary(i,1) = mean(Customer_4_arrivals(Customer_4_arrivals(:,2) == i,1) - Customer_4_arrivals(Customer_4_arrivals(:,2) == i,4));
    Customer_4_summary(i,2) = std(Customer_4_arrivals(Customer_4_arrivals(:,2) == i,1) - Customer_4_arrivals(Customer_4_arrivals(:,2) == i,4));
end

Customer_4_summary

Customer_5_arrivals = [Customer_5.time, Customer_5.signals.values];
Customer_5_summary = zeros(5,2);

for i = 1:5
    Customer_5_summary(i,1) = mean(Customer_5_arrivals(Customer_5_arrivals(:,2) == i,1) - Customer_5_arrivals(Customer_5_arrivals(:,2) == i,4));
    Customer_5_summary(i,2) = std(Customer_5_arrivals(Customer_5_arrivals(:,2) == i,1) - Customer_5_arrivals(Customer_5_arrivals(:,2) == i,4));
end

Customer_5_summary



Customer_CycleTime = [Customer_1_arrivals(:,1) - Customer_1_arrivals(:,4); ...
                        Customer_2_arrivals(:,1) - Customer_2_arrivals(:,4); ...
                        Customer_3_arrivals(:,1) - Customer_3_arrivals(:,4); ...
                        Customer_4_arrivals(:,1) - Customer_4_arrivals(:,4); ...
                        Customer_5_arrivals(:,1) - Customer_5_arrivals(:,4)];
                    
                    
Customer_summary = [mean(Customer_CycleTime), std(Customer_CycleTime)]