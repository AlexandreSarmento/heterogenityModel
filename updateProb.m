function [probE1,probE0] = updateProb(L,pickIdx,alphaN,deltaN,rhoN,S)

% This function update the probalbilities

%% input
% L: lattice
% pickIdx: adress of the choosen cell
% alphaN: cell division rates
% deltaN: cell migration rates
% rhoN: cell death rates
% S: quiescence rates

%% output

% probE1: list of the state transition's probabilities when there is one or more first empty neighbors. 
% probE0: list of the state transition's probabilities when there is no first empty neighbors.

mkr = L(pickIdx); % does the chossen cell is proliferative or migratory?

P_alpha = alphaN(mkr)/(alphaN(mkr) + rhoN(mkr) + deltaN(mkr)); % probability of cell division
    
P_delta = (alphaN(mkr) + deltaN(mkr))/(alphaN(mkr) + rhoN(mkr) + deltaN(mkr)); % probability of cell migration

P_rho = rhoN(mkr)/(S + rhoN(mkr)); % probability of cell death

P_S = S/(S + rhoN(mkr)); %probability of cell quiescence

% Is there one or more first empty neighbors?
probE1 = [P_alpha (P_alpha + P_delta) 1];  

% Is there no first empty neighbors?
probE0 = [P_S P_rho]; 


end