%% Aggregate Planning
% Aggregate planning the long-range planning function that determines the
% resource levels, e.g. workforce levels, inventory levels, etc., and the
% production levels required over the planning horizon to meet forecasted
% demand.

%%
% This section contains a optimization analysis module, AggregatePlanning(), that optimizes the
% resource and production levels for a production system and a system
% simulation module, ProductionSystem, that simulates the expected
% performance of the aggregate plan output by the optimization model.



%% Aggregate Planning Optimization Model
% AggregatePlanning formulates and solves a Linear Programming
% Optimization model using the CPLEX solver to solve an Aggregate Planning
% problem, specifically (at this time) the workforce planning aspect. The
% system parameters are set within the AggregatePlanning file.


[Production, Workforce, Overtime] = AggregatePlanning;

%%
% TO DO: Description of the output

%%
% The AggregatePlanning model is a deterministic optimization model, so the
% next step is to examine the performance of this aggregated and
% deterministic solution in a simulation system model.

%% Deterministic Production System Simulation Model
% The ProductionSystem model simulates the performance of the output of the
% aggregate planning model. Initially, we'll validate the simulation model
% by running a deterministic version. Then we'll add variable to the
% production process and examine the performance and robustness of the
% deterministic solution.

[meanTotalProfit, varTotalProfit, meanServiceLevel, varServiceLevel ] = ProductionSystem(Production, Workforce, Overtime)

%%
% In this example, the profit output from the optimization model matches the
% meanTotalProfit from the simulation and the meanServiceLevel is 1. This
% is because the system simulation is deterministic, so the
% ProductionSystem simulates exactly what the AggregatePlanning optimized.

%% Stochastic Production System Simulation Model
% The next step is to examine the quality of the aggregate
% planning solution in a system model with uncertainty. The sources of
% uncertainty are:
%
% * Proces uncertainty: If b is the total number of labor hours required to produce one unit,
% then varB is the variance in labor hours required to produce one unit (for a normal distribution).
% {'varB', '0.1'}
% * Resource uncertainty: Availability defines the productivity of the labor, e.g. they may not
% always be available. Given as a range of availabililty in each period (for a uniform distribution) {'availability', '[0.9,1]'}
% * Demand uncertainty: Defines the variability expected for demand in each
% period, given as a vector of standard deviations of demand in each
% period. For example, if we assume the standard deviation is 10% of the demand in the period: {'stdevDemand', '0.1*meanDemand'}


[meanTotalProfit, varTotalProfit, meanServiceLevel, varServiceLevel ] = ProductionSystem(Production, Workforce, Overtime, ...
    {'varB', '0.1'}, {'availability', '[0.9,1]'}, {'stdevDemand','0.1*meanDemand'})

%%
% Compared to the deterministic simulation of the production system, the
% result is that the mean total profit is lower and the service level is
% lower as well. This is the result of assuming perfect knowledge and
% system execution when determining resource levels in the optimization
% model.

%% Incorporating Uncertainty into the Optimization Process
% While more complex and detailed methods for stochastic optimization exist
% and should be covered at a later point, in this section, we'll discuss a
% practical approach to incorporating uncertainty into the aggregate
% planning process. This approach inflates the expected demand and reduces
% the expected productivity of the resources, which buffers out uncertainty
% in the long run.

[Production, Workforce, Overtime] = AggregatePlanning({'meanDemand', '1.25*meanDemand'}, {'b', '1.25*b'});

%%
% Then we'll run the recommendations of the aggregate planning process
% through the system model to see if expected performance is improved.

[meanTotalProfit, varTotalProfit, meanServiceLevel, varServiceLevel ] = ProductionSystem(Production, Workforce, Overtime, ...
    {'varB', '0.1'}, {'availability', '[0.9,1]'}, {'stdevDemand','0.1*meanDemand'})

%% 
% Obviously in this case, we added too much buffer to the aggregate
% planning process and while the service level is 100%, the total profit is
% signficantly lower. The process of selecting the optimal amount of buffer
% is an optimization process itself and left as an exercise or future work

%% Conclusions and Future Work
% While the aggregate planning process optimizes the resource levels to
% maximize profit, the resulting solution is not robust in a stochastic
% system. The lesson here is that this is actually true of most deterministic optimization models. 
% In practice, rules of thumb such as inflated demand or deflated productivity estimates are applied to correct for this lack
% of robustness and arrive at an implementable recommendation. Future work
% in this section includes:
%
% * Extending the workforce planning model to incorporate complete
% Agregate and Production Planning
% * Incorporating multi-resource models (multiple resources and inventory)
% * Proposing a stochastic optimization approach to replace the inflation
% factors