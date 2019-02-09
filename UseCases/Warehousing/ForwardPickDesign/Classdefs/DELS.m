classdef DELS < handle
    %DELS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ResourceSet@Resource
        Facility@Facility
        Controller@Controller
    end
    
    methods
        function addController(self, Controller)
            self.Controller = Controller;
            Controller.DELS = self;
        end
    end
    
end

