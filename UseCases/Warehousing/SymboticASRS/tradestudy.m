
function [blocktime, waittime]  = tradestudy (model)

tic;
for i = 6:24
    set_param(strcat(model, '/Resource_Pool_TypeSelector'), 'Quantity', num2str(i));
    
    strcat('Selector Qty', num2str(i))
    
    for j = 25: 40
        set_param(strcat(model, '/Subsystem'), 'popupqty', num2str(j));
        set_param(strcat(model, '/Subsystem1'), 'popupqty', num2str(j));
        set_param(strcat(model, '/Subsystem2'), 'popupqty', num2str(j));
        set_param(strcat(model, '/Subsystem3'), 'popupqty', num2str(j));
        set_param(strcat(model, '/Subsystem4'), 'popupqty', num2str(j));
        set_param(strcat(model, '/Subsystem5'), 'popupqty', num2str(j));
        
        sim(model);
        
        blocktime(j,i) = calculate_blocktime(intergeneration_time.time, 5.5, 10000);
        waittime(j, i) = avg_wait.signals.values(end);
        
    end
    
end
toc
'complete'
end

function blockpct =  calculate_blocktime(actual_intergeneration, expected_intergeneration, simtime)

total_blocktime = 0;

for i = 3 : length(actual_intergeneration)
    
    total_blocktime = total_blocktime + (actual_intergeneration(i) - actual_intergeneration(i-1) - expected_intergeneration); 
    
end
    
    blockpct = total_blocktime / simtime;
    

end