function yout = gomCurve(par,t)

% par(1) = No
% par(2) = K
% par(3) = gamma
yout = par(2)*exp(log(par(1)/par(2))*exp(-par(3).*t));

end