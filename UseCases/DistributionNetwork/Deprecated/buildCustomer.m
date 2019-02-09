customer_comm_set = commodity_set([commodity_set.Origin] ==1);

set_param('Distribution/Customer_1/Path Combiner', 'NumberInputPorts', num2str(length(customer_comm_set)));

%LConn1

PortSet = get_param('Distribution/Customer_1/Path Combiner', 'PortConnectivity');

for i = 1:length(customer_comm_set)
    position = get_param('Distribution/Customer_1/Path Combiner', 'Position') - [400 0 400 0] + [0 (i-1)*100 0 (i-1)*100];
%add the block
    block = add_block(strcat('Distribution_Library/CommoditySource'), strcat('Distribution/Customer_1/Commodity_',...
        num2str(customer_comm_set(i).ID)), 'Position', position);
    set_param(block, 'LinkStatus', 'none');
    
    set_param(block, 'Mean', strcat('2000/', num2str(customer_comm_set(i).Quantity)))
    %AttributeValue = '[Route]|Origin|Destination|Start'
    set_param(block, 'AttributeValue', strcat('[',num2str(customer_comm_set(i).Route),']|', num2str(customer_comm_set(i).Origin), '|', num2str(customer_comm_set(i).Destination), '|1'));
    
    add_line('Distribution/Customer_1', strcat('Commodity_', num2str(customer_comm_set(i).ID), '/RConn1'), strcat('Path Combiner/LConn', num2str(i)));
end