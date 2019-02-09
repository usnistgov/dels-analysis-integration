function corrections(Model)
%CORRECTIONS ad-hoc corrections to the simulation model
%   There are some outstanding issues to resolve in auto generating the
%   simulation model. Until I have a formal solution, the ad-hoc methods
%   will have to suffice

customerbase_data(Model);
depot_numbering(Model);
supplierbase_data(Model);
set_inventory_metrics(Model);

end


function customerbase_data(Model)
%For each customerbase, assigns the corresponding variable from the
%workspace.

customerbase_list = find_system(Model, 'Regexp', 'on', 'SearchDepth', 1, 'Name', '^CustomerBase');

for i = 1:length(customerbase_list)
   customer = regexp(customerbase_list{i}, '[/]', 'split');
   %set_param('HubDepotModel_debug/CustomerBase_1/CustomerBase/Consumption_Component', 'VectorOutputValues', 'CustomerBase_1(:,1)')
   set_param(strcat(customerbase_list{i}, '/CustomerBase/Consumption_Component'), 'VectorOutputValues', strcat(customer{end},'(:,1)'));
   set_param(strcat(customerbase_list{i}, '/CustomerBase/Order_Quantity'), 'VectorOutputValues', strcat(customer{end},'(:,2)'));
   set_param(strcat(customerbase_list{i}, '/CustomerBase/Order_Time'), 'VectorOutputValues', strcat(customer{end},'(:,3)'));
    
end

end

function depot_numbering(Model)
%Using the prototype pattern causes the customer/supplier routing to not
%instantiate correctly, ie Depot_3 should be Hub_1's customer #3
%This code goes through an provides new numbering

depot_list = find_system(Model, 'Regexp', 'on', 'SearchDepth', 1, 'Name', '^Depot');

for i = 1:length(depot_list)
   block = strcat(depot_list{i},'/Storage_Subsystem/<<SOURCE>> Source_Stocked_Product/sS1.1_Schedule_Product_Deliveries_PLANT/Set_Procurement_Order');
   procurement_attributevalues = get_param(block, 'AttributeValue');
   depot_number = regexp(depot_list{i}, '[_]', 'split');

   set_param(block, 'AttributeValue', strcat(procurement_attributevalues(1:end-1), depot_number{end}));

    
end
end

function supplierbase_data(Model)
%Rename the variables referenced in the supplier,
%Each supplierbase/supplier (not really differentiated right now) has a
%table of lead times for each part, this information is stored on the
%MATLAB workspace. ie LT_SupplierBase_1

%get a list of supplierbase objects in the model (1 level only)
supplierbase_list = find_system(Model, 'Regexp', 'on', 'SearchDepth', 1, 'Name', '^SupplierBase');

for i = 1:length(supplierbase_list)
   supplier = regexp(supplierbase_list{i}, '[/]', 'split');
   %set_param('HubDepotModel_debug/SupplierBase_1/SupplierBase/LT_Lookup/Set_LT_values', 'AttributeValue', 'LT_SupplierBase_1')
   set_param(strcat(supplierbase_list{i}, '/SupplierBase/LT_Lookup/Set_LT_values'), 'AttributeValue', strcat('LT_', supplier{end}));
   
end

end

function set_inventory_metrics(Model)


storagesubsystem_list = find_system(Model, 'Regexp', 'on', 'SearchDepth', 2, 'Name', 'Storage_Subsystem');

for i = 1:length(storagesubsystem_list)
    storagesubsystem_parent = get_param(storagesubsystem_list{i}, 'Parent');
    storagesubsystem_parentname = regexp(storagesubsystem_parent, '[/]', 'split');
    
    set_param(strcat(storagesubsystem_list{i}, '/<<ENABLE>> Manage_Product_Inventory/Inventory_Position_Metric'), 'VariableName', strcat('Inventory_Position_', storagesubsystem_parentname{end}));
    set_param(strcat(storagesubsystem_list{i}, '/<<ENABLE>> Manage_Product_Inventory/Net_Inventory_Metric'), 'VariableName', strcat('Net_Inventory_', storagesubsystem_parentname{end}));
    
end

end