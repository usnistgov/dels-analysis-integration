function import_SupplierCustomer_instancedata( Model, database)
%import_SupplierCustomer_instancedata reads the customer consumption data
%from Access db and writes them to .mat file. The .mat file is loaded into
%the workspace prior to simulation


warning('off', 'MATLAB:MatFile:OlderFormat');

%open the .mat file that stores the instance data
m = matfile('SupplierCustomerData.mat', 'Writable', true);
customerbase_list = find_system(Model, 'Regexp', 'on', 'SearchDepth', 1, 'Name', '^CustomerBase');

% for each customerbase object, there is a correspond variable in the
% workspace that holds the component, quantity, and time
for i = 1:length(customerbase_list)
    sqlstring = strcat('SELECT * FROM CustomerBase_Data WHERE CustomerBase_ID = ', num2str(i), ';');
    recordstruct = getrecords(database, sqlstring);
    
    customerbase = regexp(customerbase_list{i}, '[/]', 'split');
    
    data = zeros(length(recordstruct.data), 4);
    
    %break the structure into arrays
    for j = 1:length(recordstruct.data)
        data(j,1) = recordstruct.Component_ID{j};
        data(j,2) = recordstruct.Quantity{j};
        data(j,4) = recordstruct.Consumed_Date{j};
        
        %calculate interarrival time
        if j == 1
            data(j,3) = data(j,4);
        else
            data(j,3) = data(j,4) - data(j-1,4);
        end %end calculate interarrival time

    end %for each record in customerbase data
   m.(customerbase{2}) = data;     
end %for each customer base


%load supplier lead time data
sqlstring = strcat('SELECT Component_Table.Part_Lead_Time FROM Component_Table ORDER BY Component_Table.Component_ID;');
recordstruct = getrecords(database, sqlstring);

data = zeros(length(recordstruct.data),1);
for j = 1:length(recordstruct.data)
    data(j,1) = recordstruct.Part_Lead_Time{j};
end %for each record in leadtime data
m.('LT_SupplierBase_1') = data;

%set inventory paramaters
%placeholder to input more values in the future
data = ones(length(recordstruct.data),4);
data(:,1)=13*data(:,1);
data(:,2)=13*data(:,2);
data(:,3)=10*data(:,3);
data(:,4)=5*data(:,4);
m.('InventoryParameters') = data;

end

