function [pop,pop1,pop2,popS,tempo] = calcPopDens(data)

% we organized group of simulation according the groups of k values such that group 1 would be
% $k_p=k_m=1$, group 2 would be $k_p=k_m=10$, group 3 would be
% $k_p=10,k_m=1$ and group 4 would be $k_p = 1,k_m = 10$.
% Each group mentioned above contain 64 experimental condition to simulation, 64 is product of the amount of
% $\overline{N}$ times $\overline{alpha}$. Just highligthing that we fixed the
% values of the parameters $A_{i}$, $D_{i}$ and $R_{i}$ through al
% simulations.

%% input
% auxFi; list of variables which could be ploted
% data: output table data from simulation

%% output
% pop: population density average
% pop1: proliferative cells density average
% pop2: migratory cells density average
% tempo: time average
% popS: standard deviation of total population

auxFi = 1:15;
ndata = numel(auxFi); % the total number of columns from data output file divided by the number of simulation per amount
% of experimental group according $k_{i}$ values will give us and increment
% parameter to seek the specific data to plot.

ict = 1; % initial column to time
icf = 4; % initial column to total population density
icf1 = 2; % initial column to total proliferative population density
icf2 = 3; % initial column to total migratory population density

colf = icf:ndata:size(data,2); % columns set where we can find data related to total population density
colt = ict:ndata:size(data,2); % columns set where we can find data related to time
colf1 = icf1:ndata:size(data,2); % columns set where we can find data related to proliferative cells density
colf2 = icf2:ndata:size(data,2); % columns set where we can find data related to migratory cells density
t = data(:,colt,:); % table with datas related to time
f = data(:,colf,:); % table with data related to population density
f1 = data(:,colf1,:); % table with data related to proliferative cells
f2 = data(:,colf2,:); % table with data related to migratory cells

pop = zeros(1,16*4); % population density average
pop1 = size(pop); % proliferative cells density average
pop2 = size(pop); % migratory cells density average
tempo = size(pop); % time average
popS = size(pop); % standard deviation

% once we've made stochastic modelling naturally some simulation will
% finish early or more late depending the parameter values, consequently all columns in the dataFi variable won't
% have the same amount of data. Furthermore, some trajectories can be interruped because all cells die at the very
% first iteractions. Thus we calculated average value and standar deviation
% per each row and dimension.

for col = 1:numel(colf)
    for row = 1:size(f,1) % our priotity is collect data untill the last time point
        for dim = 1:size(f,3)
            if (nnz(f(row,col,:)) >= 1) % it is to avoid 0/0 which is NaN
                
                pop(row,col) = sum(f(row,col,:))/nnz(f(row,col,:)); % here we consider calculate the average taking account the trajectory where
                % there wasnt very early interruption of simulation due to population extinction
                pop1(row,col) = sum(f1(row,col,:))/nnz(f1(row,col,:));
                pop2(row,col) = sum(f2(row,col,:))/nnz(f2(row,col,:));
                tempo(row,col) = sum(t(row,col,:))/nnz(t(row,col,:));
                aux1 = (f(row,col,dim) - pop(row,col))^2;
                aux2 = sum(aux1)/4;
                popS(row,col) = sqrt(aux2);
            else
                pop(row,col) = mean(f(row,col,:),3);
                pop1(row,col) = mean(f1(row,col,:),3);
                pop2(row,col) = mean(f2(row,col,:),3);
                popS(row,col) = std(f(row,col),0,3);
                tempo(row,col) = std(t(row,col),0,3);
            end
            
        end
    end
end
% once migratory cells emerge from proliferative ones, we expect the when this function calculate the average of migratory cells in very begin
% take the risk to compute 0/0 and store NaN ate pop2. 
xx = isnan(pop2);
pop2(xx) = 0;
end