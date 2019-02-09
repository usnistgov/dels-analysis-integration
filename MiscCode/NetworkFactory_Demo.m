Model = 'WorkstationNetworkModel'
open(Model)
open('DELS_Library')
simeventslib

% The Workstation Process Model
% Case 1: The pseudo-abstract NodeFactory generates the pseudo-abstract class Node 

Model = 'WorkstationNetworkModel'
database = 'C:\Users\tsprock3\Desktop\WSProcessModel.accdb'
ef1 = EdgeFactory
ef1.Model = Model
ef1.database = database
ef1.setEdgeSet

nf1 = NodeFactory %Use default superclass of Node
nf1.Model = Model
nf1.database = database
nf1.setNodeSet
nf1.allocate_edges(ef1.EdgeSet)
nf1.CreateNodes
ef1.CreateEdges

%Case 2: The pseudo-abstract NodeFactory generates the concrete product Workstation
        %same edgeset and factory as first case
nf2 = NodeFactory('Workstation')
nf2.Model = Model
nf2.database = database
nf2.setNodeSet
nf2.allocate_edges(ef1.EdgeSet)
nf2.CreateNodes
ef1.CreateEdges

%Case 3: The concrete WorkstationFactory generates the concrete product Workstation
    %The correct implementation of Abstract Factory calls for it to be
    %subclassed for each type of concrete product. Here we have created a
    %Workstation Factory for creating concrete products workstations.
wf1 = WorkstationFactory
wf1.Model = Model
wf1.database=database
wf1.setNodeSet
wf1.allocate_edges(ef1.EdgeSet)
wf1.CreateNodes
ef1.CreateEdges

%Case 4: The pseudo-abstract NodeFactory generates the pseudo-abstract class Node
            %for the Functional Requirements Network
database = 'C:\Users\tsprock3\Desktop\FRNModel.accdb'
ef3 = EdgeFactory
ef3.database = database
ef3.Model = Model
ef3.setEdgeSet

nf3 = NodeFactory
nf3.Model = Model
nf3.database = database
nf3.setNodeSet
nf3.allocate_edges(ef3.EdgeSet)
nf3.CreateNodes
ef3.CreateEdges

%Case 5: The pseudo-abstract NodeFactory generates the concrete product
            %FRN_Node with the same edgeset and factory as first case

%Case 6: The pseudo-abstract NodeFactory generates the pseudo-abstract class Node
            %for the Hub Depot Model
%This use case is important because in the case where there is limited
%post-instantiation modification, it appears easier to parameterize the
%abstract factory to generate different concrete products
            
database = 'C:\Users\tsprock3\Desktop\HubDepotModel.accdb'
ef4 = EdgeFactory
ef4.Model = Model
ef4.database = database
ef4.setEdgeSet

nf4 = NodeFactory
nf4.Model = Model
nf4.database = database
nf4.setNodeSet
nf4.allocate_edges(ef4.EdgeSet)
nf4.CreateNodes
ef4.CreateEdges

