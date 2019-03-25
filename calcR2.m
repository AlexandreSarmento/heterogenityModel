function rG = calcR2(pop,PG)

% this function calculate the correlation coefficient between simulation
% data and Gompertz model

%% input
% pop: data from simulation
% PG: data from Gompertz model adjusted to simulation data 
s = size(pop,1);
x = pop;
yG = PG;

xyG = x.*yG;
rG = (s*(sum(xyG)) - (sum(x)*sum(yG)))./(sqrt((s*sum(x.^2) - sum(x)^2)*(s*sum(yG.^2) - sum(yG)^2)));

end

