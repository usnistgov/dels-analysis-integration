classdef NetworkFactory < handle
    %NETWORKFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %Model %where the network factory will operate
        %modelLibrary % Source of simulation objects to clone from
        %NetworkObject@Network %what network object the factory will build
        %nodeFactorySet@NodeFactory
        %edgeFactorySet@EdgeFactory
        
    end
    
    methods
        function NF = NetworkFactory(varargin)
            %Add the ability to call the constructor with model and
            %modellibrary; can't really distinguish betweenn them though.
        end
        function buildSimulation(NF, varargin)
%             open(NF.Model);
%             delete_model(NF.Model);
%             open(NF.modelLibrary);
%             simeventslib;
%             simulink;
%             
%             %Currently constructs a DES representation of the Network
%             for ii = 1:length(NF.nodeFactorySet)
%                 NF.nodeFactorySet(ii).CreateNodes;
%             end
%             
%             
%             for ii = 1:length(NF.edgeFactorySet)
%                 %In the simulation context these are technically flow edges
%                 %connecting flow ports that provide the interface to the
%                 %nodes/DELS
%                 NF.edgeFactorySet(ii).CreateEdges;
%             end
%             
%             se_randomizeseeds(NF.Model, 'Mode', 'All', 'Verbose', 'off');
%             save_system(NF.Model);
%             close_system(NF.Model,1);
        end %end buildSimulation
        
        function addNodeFactory(NF, nodeFactory)
%             for ii = 1:length(nodeFactory)
%                if isa(nodeFactory(ii), 'NodeFactory')
%                    nodeFactory(ii).Model = NF.Model;
%                    nodeFactory(ii).Library = NF.modelLibrary;
%                    NF.nodeFactorySet(end+1) = nodeFactory(ii);
%                else
%                    fprintf('nodeFactory %i is not a valid NodeFactory', ii);
%                end
%             end
        end
        
        function addEdgeFactory(NF, edgeFactory)
%             for ii = 1:length(edgeFactory)
%                 if isa(edgeFactory(ii), 'EdgeFactory')
%                     edgeFactory(ii).Model = NF.Model;
%                     NF.edgeFactorySet(end+1) = edgeFactory(ii);
%                 end
%             end
         end
    end
    
end

