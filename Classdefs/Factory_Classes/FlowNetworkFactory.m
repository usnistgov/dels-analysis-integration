classdef FlowNetworkFactory < NetworkFactory
    %NETWORKFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Model %where the network factory will operate
        modelLibrary % Source of simulation objects to clone from
        %NetworkObject@Network %what network object the factory will build
        flowNodeSet %cell of FlowNodes
        flowEdgeSet@FlowEdge  
    end
    
    methods
        function NF = NetworkFactory(varargin)
            %Add the ability to call the constructor with model and
            %modellibrary; can't really distinguish betweenn them though.
        end
        function buildSimulation(NF)
            open(NF.Model);
            delete_model(NF.Model);
            open(NF.modelLibrary);
            simeventslib;
            simulink;
            
            allocateEdges(NF);
            
            NF.CreateNodes;
            
            %In the simulation context these are technically flow edges
            %connecting flow ports that provide the interface to the
            %flow nodes/DELS
            NF.CreateEdges;

            
            se_randomizeseeds(NF.Model, 'Mode', 'All', 'Verbose', 'off');
            save_system(NF.Model);
            close_system(NF.Model,1);
        end %end buildSimulation
        
        function CreateNodes(NF)
           echelon_position = [0 0 0 0 0 0 0 0 0 0]; %[1 2 3 4 5 6 7 8 9 10]
           for ii = 1:length(NF.flowNodeSet)
               
               %set position of new block relative to its echelon and
               %previous blocks in that echelon
               position = [350*(NF.flowNodeSet{ii}.Echelon-1) echelon_position(NF.flowNodeSet{ii}.Echelon)  ...
                   200+350*(NF.flowNodeSet{ii}.Echelon-1) echelon_position(NF.flowNodeSet{ii}.Echelon)+65+ 10*max(length(NF.flowNodeSet{ii}.INEdgeSet), length(NF.flowNodeSet{ii}.OUTEdgeSet))];
               echelon_position(NF.flowNodeSet{ii}.Echelon) = echelon_position(NF.flowNodeSet{ii}.Echelon) + ...
                   100+65+ 10*max(length(NF.flowNodeSet{ii}.INEdgeSet), length(NF.flowNodeSet{ii}.OUTEdgeSet));
               
             
               %add the block
               NF.flowNodeSet{ii}.SimEventsPath = strcat(NF.Model, '/', NF.flowNodeSet{ii}.Name);
               NF.flowNodeSet{ii}.Model = NF.Model;
               add_block(strcat(NF.modelLibrary, '/', NF.flowNodeSet{ii}.Type), NF.flowNodeSet{ii}.SimEventsPath, 'Position', position);
               set_param(NF.flowNodeSet{ii}.SimEventsPath, 'LinkStatus', 'none');
               
               %NodeFactory is the Director
               %Node acts as a ConcreteBuilder
               NF.flowNodeSet{ii}.decorateNode;
         
           end
           
        end %Role: ConcreteFactory
        
        function CreateEdges(NF)
            %For each edge in edgeset, use the add_line method to add a
            %connector line in the simulation
            for ii = 1:length(NF.flowEdgeSet)
                %check nestedness: needs to be fixed somehow to allow nodes
                %to connect to their nested networks
                add_line(NF.Model, strcat(NF.flowEdgeSet(ii).Origin.Name,'/', NF.flowEdgeSet(ii).OriginPort.Conn),...
                    strcat(NF.flowEdgeSet(ii).Destination.Name,'/', NF.flowEdgeSet(ii).DestinationPort.Conn), 'autorouting', 'on');
            end
        end %creatEdges
        
        function addFlowNode(NF, flowNode)
            for ii = 1:length(flowNode)
               if isa(flowNode(ii), 'FlowNetwork')
                   NF.flowNodeSet{end+1} = flowNode(ii);
               else
                   fprintf('flowNode %i is not a valid FlowNetwork', ii);
               end
            end
        end
        
        function addFlowEdge(NF, flowEdge)
            for ii = 1:length(flowEdge)
                if isa(flowEdge(ii), 'FlowEdge')
                    NF.flowEdgeSet(end+1) = flowEdge(ii);
                end
            end
        end
        
        function allocateEdges(NF)
            %ALLOCATE_EDGES Summary of this function goes here
            %   Detailed explanation goes here
            for jj = 1:length(NF.flowNodeSet)
                for ii = 1:length(NF.flowEdgeSet)
                    NF.flowNodeSet{jj}.addEdge(NF.flowEdgeSet(ii));
                end %for each edge
                
                %NF.flowNodeSet{jj}.assignPorts;
            end %for each node
        end
    end
    
end

