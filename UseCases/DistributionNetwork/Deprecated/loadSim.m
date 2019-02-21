        warning('off','all');
        Model = 'Distribution';
        load_system(Model)
        se_randomizeseeds(Model, 'Mode', 'All', 'Verbose', 'off');