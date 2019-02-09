aisles = 51;
PD_aisle = 26;
slot_width = 10;
aisle_width = 30;
slots = 250;
cross_aisle = 100;

%% Initialize Layout Procedure
N = 1;
E = 1;
NodeSet = Node(0,0,0,0,'P&D');
NodeSetList = [0, 0,0,0]; %[ID, X, Y, Z]
EdgeSet = Edge;
EdgeSet(1).Edge_ID = 0;
EdgeSetList = [0 0 0 0];
cross_aisle_width = 3*slot_width;

%% Generate Aisles (Columns) of Travel Nodes
for aisle_count = 0:aisles-1
    %Generate the Bottom Cross Aisle    
    NodeSet(end+1) = Node(N, 0.5*aisle_width+aisle_count*aisle_width, 0.25*cross_aisle_width, 0, 'Transport');
    NodeSetList = [NodeSetList; N, 0.5*aisle_width+aisle_count*aisle_width, 0.25*cross_aisle_width, 0,];
     
    EdgeSet(end+1) = Edge(E, N, N+1, 'UoH');
    EdgeSet(end+1) = Edge(E+1, N+1, N, 'UoH');
    EdgeSetList = [EdgeSetList; E, N, N+1, 0; E+1, N+1, N, 0];
    

    N= N+1;
    E = E+2;
    for slot_count = 0:slots-1
        
        NodeSet(end+1) = Node(N, 0.5*aisle_width+aisle_count*aisle_width, 0.5*slot_width + slot_count*slot_width + 0.25*cross_aisle_width,0, 'Transport');
        NodeSetList = [NodeSetList; N, 0.5*aisle_width+aisle_count*aisle_width, 0.5*slot_width + slot_count*slot_width + 0.25*cross_aisle_width,0];
         
        EdgeSet(end+1) = Edge(E+1, N+1, N, 'UoH');
        EdgeSet(end+1) = Edge(E, N, N+1, 'UoH');
        EdgeSetList = [EdgeSetList; E, N, N+1, 0; E+1, N+1, N, 0];
        
        
        N = N+1;
        E = E+2;
    end
    %Generate the Top Cross Aisle
    NodeSet(end+1) = Node(N, 0.5*aisle_width+aisle_count*aisle_width, slots*slot_width + 0.5*cross_aisle_width,0, 'Transport');
    NodeSetList = [NodeSetList;N, 0.5*aisle_width+aisle_count*aisle_width, slots*slot_width + 0.5*cross_aisle_width,0];
    N= N+1;
end

%% Addition of the Cross Aisles on Top, Middle, and Bottom
% Can generalize to arbitrary number of cross aisles (perhaps with the mild
% condition that the aisle node was already placed in previous section
Cross_Aisle_Set = [0.25*cross_aisle_width, slots*slot_width + 0.5*cross_aisle_width, cross_aisle*slot_width + 0.5*cross_aisle_width];

for j = 1:length(Cross_Aisle_Set)

    Cross_Aisle = findobj(NodeSet, 'Y', Cross_Aisle_Set(j));

    for i = 1:length(Cross_Aisle)-1
        EdgeSet(end+1) = Edge(E, Cross_Aisle(i).Node_ID, Cross_Aisle(i+1).Node_ID, 'UoH');
        EdgeSet(end+1) = Edge(E+1, Cross_Aisle(i+1).Node_ID, Cross_Aisle(i).Node_ID, 'UoH');
        EdgeSetList = [EdgeSetList; E, Cross_Aisle(i).Node_ID, Cross_Aisle(i+1).Node_ID, 0; E+1, Cross_Aisle(i+1).Node_ID, Cross_Aisle(i).Node_ID, 0];
        E = E+2;
    end
end

%% Insert Pickup & Drop-off Point(s)
PD = Node(length(NodeSet), 0.5*aisle_width+PD_aisle*aisle_width, 0, 0, 'P&D');
NodeSetList = [NodeSetList;length(NodeSet), 0.5*aisle_width+PD_aisle*aisle_width, 0, 0];

n1 = findobj(findobj(NodeSet, 'X', 0.5*aisle_width+PD_aisle*aisle_width), 'Y', 0.25*cross_aisle_width);

NodeSet(end+1) = PD;
EdgeSet(end+1) = Edge(E+1, n1.Node_ID, PD.Node_ID, 'UoH');
EdgeSet(end+1) = Edge(E, PD.Node_ID, n1.Node_ID, 'UoH');
EdgeSetList = [EdgeSetList; E, PD.Node_ID, n1.Node_ID, 0; E+1, n1.Node_ID, PD.Node_ID, 0];

%% Commit Data to Network Structure
MovementNetwork = Network;
MovementNetwork.NodeSet = NodeSet(2:end);
MovementNetwork.NodeSetList = NodeSetList(2:end, :);
MovementNetwork.EdgeSet = EdgeSet;
MovementNetwork.EdgeSetList = EdgeSetList(2:end , : );
MovementNetwork.setEdgeWeights;

MovementNetwork.EdgeSetAdjList = list2adj(MovementNetwork.EdgeSetList(:, 2:end));


%% Generate Storage Network 
%(two storage nodes for each travel node in an aisle)
NodeSet = Node(0,0,0,0,'P&D');
NodeSetList = [0, 0,0,0];
EdgeSet = Edge;
EdgeSet(1).Edge_ID = 0;
EdgeSetList = [0 0 0 0];

for aisle_count = 0:aisles-1
    %Skip the Bottom Cross Aisle    

    for slot_count = 0:slots-1
        if eq(any(slot_count == [cross_aisle-1, cross_aisle, cross_aisle+1]), 1)
            continue
        else
            %Create Two Storage Nodes in the Same Location as the Transport
            %Node
            NodeSet(end+1) = Node(N, 0.5*aisle_width+aisle_count*aisle_width, 0.5*slot_width + slot_count*slot_width + 0.25*cross_aisle_width,0, 'Storage');
            NodeSetList = [NodeSetList; N, 0.5*aisle_width+aisle_count*aisle_width, 0.5*slot_width + slot_count*slot_width + 0.25*cross_aisle_width,0];
            
            tn = MovementNetwork.NodeSetList(MovementNetwork.NodeSetList(:, 2) == 0.5*aisle_width+aisle_count*aisle_width & MovementNetwork.NodeSetList(:, 3) == 0.5*slot_width + slot_count*slot_width + 0.25*cross_aisle_width);
            EdgeSet(end+1) = Edge(E+1, MovementNetwork.NodeSetList(tn, 1), N, 'UoH');
            EdgeSet(end+1) = Edge(E, N, MovementNetwork.NodeSetList(tn, 1), 'UoH');
            %Fudge the distance to make the shortest path alg work.
            EdgeSetList = [EdgeSetList; E, N, MovementNetwork.NodeSetList(tn, 1), 0.001; E+1, MovementNetwork.NodeSetList(tn, 1), N, 0.001];
            
            N = N+1;
            E = E+2;
            
            NodeSet(end+1) = Node(N, 0.5*aisle_width+aisle_count*aisle_width, 0.5*slot_width + slot_count*slot_width + 0.25*cross_aisle_width,0, 'Storage');
            NodeSetList = [NodeSetList; N, 0.5*aisle_width+aisle_count*aisle_width, 0.5*slot_width + slot_count*slot_width + 0.25*cross_aisle_width,0];
            
            EdgeSet(end+1) = Edge(E+1, MovementNetwork.NodeSetList(tn, 1), N, 'UoH');
            EdgeSet(end+1) = Edge(E, N, MovementNetwork.NodeSetList(tn, 1), 'UoH');
            EdgeSetList = [EdgeSetList; E, N, MovementNetwork.NodeSetList(tn, 1), 0.001; E+1, MovementNetwork.NodeSetList(tn, 1), N, 0.001];
            
            N = N+1;
            E = E+2;
        end
    end
    %Skip the Top Cross Aisle
end

%% Commit Data to Network Structure
StorageNetwork = Network;
StorageNetwork.NodeSet = NodeSet(2:end);
StorageNetwork.NodeSetList = NodeSetList(2:end, :);
StorageNetwork.EdgeSet = EdgeSet;
StorageNetwork.EdgeSetList = EdgeSetList(2:end , : );
StorageNetwork.EdgeSetAdjList = list2adj(StorageNetwork.EdgeSetList(:, 2:end));

%% Calculate Relative Value of Each Storage Location.
A = list2adj([MovementNetwork.EdgeSetList(:, 2:end); StorageNetwork.EdgeSetList(:, 2:end)]);
tic
D = dijk(A, PD.Node_ID, StorageNetwork.NodeSetList(:,1));
toc


