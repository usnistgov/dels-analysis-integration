function [ newT ] = RandomKick( T , nearness, alpha, costMat)
%RANDOMKICK Summary of this function goes here
%   Detailed explanation goes here


    %Alpha parameter determines the size of the candidate list
    candidate_list = randsample(1:length(T),round(alpha*length(T)));

    %Candidate is the Index in the Tour
    best_candidate = 1;
    %Find nearest neighbor for all nodes
    [cost, index] = min(costMat, [], 1);
    for i = 1:length(candidate_list)
        
        if candidate_list(i) == length(T)
            nexti = 1;
        else
            nexti = candidate_list(i) + 1;
        end

        if best_candidate == length(T)
            nextbest = 1;
        else
            nextbest = best_candidate + 1;
        end
        
       %for the candidate, compare the current edge choice against the shortest one (its nearest neighbor)
       %if this cost savings is better than the best candidate, set it as the best candidate
        if costMat(T(i), T(nexti)) - cost(T(i)) > costMat(T(best_candidate), T(nextbest)) - cost(T(best_candidate))
            best_candidate = candidate_list(i);            
        end
    end  
    %Execute three flips based on the nearness factor
        if (best_candidate+3*nearness) <= length(T)
            T = flip(T, T(best_candidate), T(best_candidate+nearness));
            T = flip(T, T(best_candidate+nearness), T(best_candidate+2*nearness));
            T = flip(T, T(best_candidate+2*nearness), T(best_candidate+3*nearness));
        else
            T = flip(T, T(best_candidate), T(best_candidate-nearness));
            T = flip(T, T(best_candidate-nearness), T(best_candidate-2*nearness));
            T = flip(T, T(best_candidate-2*nearness), T(best_candidate-3*nearness));
        end
    newT= T;


end

