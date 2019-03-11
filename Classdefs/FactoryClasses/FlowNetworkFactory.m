classdef FlowNetworkFactory < handle
    %FLOWNETWORKFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        model %where the network factory will operate
        modelLibrary % Source of analysis objects to clone from
        inputFlowNetwork@FlowNetwork
    end
    
    methods
        function self = FlowNetworkFactory(varargin)
            %Add the ability to call the constructor with model and
            %modellibrary; can't really distinguish betweenn them though.
        end
        
        function buildAnalysisModel(self, varargin)

        end %end buildAnalysisModel
        
    end
    
end

