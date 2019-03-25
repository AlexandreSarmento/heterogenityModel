function [alphaN,deltaN,rhoN] = updateRate(A,R,D,L,X,Nbar,k)

% This function updates the rates
%% input: 
% A: maximal cell division,
% D: maximal migration rates 
% R: maximal death rate 
% X: the denominator to acalculate $\overline{\alpha} = A_{i}/X$
% $\overline{N}$: the population size at which cell division rates fall on half
% k: the transition smoothness between maximal and minimal values and
% vice versa of A,R and D

%% output
% alphaN: is the cell division rates as a function of population size
% deltaN: is the migration rates as a function of population size
% rhoN: is the death rates as a function of population size

aBar = [A(1)/X; A(2)/X]; 

alphaN = [(A(1)*Nbar^k(1))/(nnz(L).^k(1) + Nbar^k(1));
    (A(2)*Nbar^k(2))/(nnz(L).^k(2) + Nbar^k(2))];

deltaN = [(D(1)*aBar(1))/(aBar(1) + alphaN(1));
    (D(2)*aBar(2))/(aBar(2) + alphaN(2))];

rhoN = [(R(1)*aBar(1))/(aBar(1) + alphaN(1));
    (R(2)*aBar(2))/(aBar(2) + alphaN(2))];

end