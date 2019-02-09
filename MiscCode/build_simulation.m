function build_simulation(Model, database)
%BUILD_SIMULATION Executes the sequence of functions to build the
%simulation

%START WITH AN EMPTY MODEL!!

%do beforehand, and edit the data as necessary
%load('C:\Users\tsprock3\Documents\MATLAB\NetworkGeneration\UseCases\InstanceData\SupplierCustomerData.mat')
%Model = 'untitled';
%database = 'C:\Users\tsprock3\Desktop\HubDepotModel.accdb';


simeventslib
open('DELS_Library')
open(Model)

[NodeSet, EdgeSet] = prepare_data(database);

nf1 = NodeFactory;
nf1.Model = Model;
nf1.NodeSet = NodeSet;
ef1 = EdgeFactory;
ef1.Model = Model;
ef1.EdgeSet = EdgeSet;
nf1.CreateNodes
ef1.CreateEdges

corrections(Model)

se_randomizeseeds(Model, 'Mode', 'All', 'Verbose', 'on')

import_SupplierCustomer_instancedata(Model, database);

disp('Complete');

end