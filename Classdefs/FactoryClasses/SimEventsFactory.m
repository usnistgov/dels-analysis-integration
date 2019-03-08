classdef SimEventsFactory < FlowNetworkFactory
    %SimEventsFlowNetworkFactory Summary of this class goes here
    %2/20/19 -- deprecated flowNode/Edge in favor of FlowNetwork
    %2/20/19 -- lower case 'model'
    
    properties
        %^model %where the network factory will operate
        %^modelLibrary % Source of simulation objects to clone from
        %^inputFlowNetwork@FlowNetwork
        flowNodeBuilders%@FlowNetworkSimEventsBuilder
        
    end
    
    methods
       
        function buildAnalysisModel(self, varargin)
            addpath dels-analysis-integration\AnalysisLibraries\SimulationModelLibrary
            open(self.model);
            self.deleteModel(self.model);
            open(self.modelLibrary);
            simeventslib;
            
            self.createFlowNodes;
            
            self.createFlowEdges;

            se_randomizeseeds(self.model, 'Mode', 'All', 'Verbose', 'off');
            save_system(self.model);
            close_system(self.model,1);
        end %end buildSimulation
        
        function createFlowNodes(self)
           echelon_position = [0 0 0 0 0 0 0 0 0 0]; %[1 2 3 4 5 6 7 8 9 10]
           for jj = 1:length(self.inputFlowNetwork.flowNodeSet)
               flowNodeSet = self.inputFlowNetwork.flowNodeSet{jj};
               for ii = 1:length(flowNodeSet)
                   
                   % find the builder associated with the flow node
                   % 3/5/19 -- changed to make system element blind to PSM builder
                   targetBuilder = FlowNetworkSimEventsBuilder.empty(0);
                   kk = 1;
                   while isempty(targetBuilder)
                        targetBuilder = findobj(self.flowNodeBuilders{kk}, 'systemElement', flowNodeSet(ii));
                        kk = kk+1;
                   end
                   
                   %set position of new block relative to its echelon and previous blocks in that echelon
                   position = [350*(targetBuilder.echelon-1) echelon_position(targetBuilder.echelon)  ...
                       200+350*(targetBuilder.echelon-1) echelon_position(targetBuilder.echelon)+65+ 10*max(length(flowNodeSet(ii).inFlowEdgeSet), length(flowNodeSet(ii).outFlowEdgeSet))];
                   echelon_position(targetBuilder.echelon) = echelon_position(targetBuilder.echelon) + ...
                       100+65+ 10*max(length(flowNodeSet(ii).inFlowEdgeSet), length(flowNodeSet(ii).outFlowEdgeSet));
                   targetBuilder.position = position;


                   %add the block
                   targetBuilder.simEventsPath = strcat(self.model, '/', flowNodeSet(ii).name);
                   targetBuilder.model = self.model;
                   add_block(strcat(self.modelLibrary, '/', targetBuilder.analysisTypeID), targetBuilder.simEventsPath, 'Position', position);
                   set_param(targetBuilder.simEventsPath, 'LinkStatus', 'none');

                   %NodeFactory is the Director
                   %Node acts as a ConcreteBuilder
                   targetBuilder.construct;
               end
           end
           
        end %Role: ConcreteFlowNodeFactory
        
        function createFlowEdges(self)
            %For each FlowEdge in flwoEdgeSet, use the add_line method to add a
            %connector line in the simulation
            currFlowEdgeSet = self.inputFlowNetwork.flowEdgeSet;
            for ii = 1:length(currFlowEdgeSet)
                %check nestedness: needs to be fixed somehow to allow nodes
                %to connect to their nested networks
                add_line(self.model, strcat(currFlowEdgeSet(ii).sourceFlowNetwork.name,'/', currFlowEdgeSet(ii).endNetwork1Port.conn),...
                    strcat(currFlowEdgeSet(ii).targetFlowNetwork.name,'/', currFlowEdgeSet(ii).endNetwork2Port.conn), 'autorouting', 'on');
            end
        end %createFlowEdges -- ROLE: ConcreteFlowEdgeFactory
        
        function addFlowNodeBuilder(self, input)
            if isa(input, 'FlowNetworkSimEventsBuilder')
                self.flowNodeBuilders{end+1} = input;
            end
        end
        
        function deleteModel(~, model)
            %DELETE_MODEL Summary of this function goes here
            %   Detailed explanation goes here

            open(model);
            a = find_system(model);
            for i = 2:length(a)
                try delete_block(a(i))
                catch, continue;
                end
            end

            l = find_system(model, 'FindAll', 'on', 'type', 'line');

            for i = 1:length(l)
                try delete_line(l(i))
                catch, continue;
                end
            end

        end %end delete_model()
    end
    
    methods (Access = private)
        
        %2/20/19 to be deprecated
        function addFlowNode(self, flowNode)
            for ii = 1:length(flowNode)
               if isa(flowNode(ii), 'FlowNetwork')
                   self.flowNodeSet{end+1} = flowNode(ii);
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
            for jj = 1:length(flowNodeSet)
                for ii = 1:length(NF.flowEdgeSet)
                    flowNodeSet{jj}.addEdge(NF.flowEdgeSet(ii));
                end %for each edge
                
                %flowNodeSet{jj}.assignPorts;
            end %for each node
        end
        

    end
    
end

