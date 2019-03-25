%% auxiliar variables to set domain and simulation output data
n = 150; % domain size
NN = n*n; % total number of cells in the grid
nrepl = 100; % number of trajectories
% auxiliar list of string to count how many variables we are interest in analyze
% t: time
% f1: density of proliferative cells
% f2: density of migratory cells
% f: density of total population
% void: amount of empty space
% Pvar: probability of generate two variants
% apN and amN: cell division rates
% dpN and dmN: cell migration rates
% rpN and rmN: cell death rates
% xaxis: X axis occupied
% yaxis: Y axis occupied
auxFi = {'t','f1','f2','f','void','Pvar','apN','amN','dpN','dmN','rpN','rmN','xaxis','yaxis','dt'};
% toData(1) = how many variable to plot?
% toData(2) = final time 
% toData(3) = this value will be assigned to another variable inside the
toData = [numel(auxFi); 700; 18];

%% input parameters
A = [1 1/4]; % maximal cell division rate
D = [1/10 1]; % maximal migration rates
R = [1/3 1/3]; % maximal death rates
Q = 1/100; % quiescence rates
nu = 1e-7; % new variants generation rates
Nbar = [0.05*NN 0.1*NN 0.2*NN 0.3*NN]; % the population size at which maximal cell division rate falls on half 
aBar = 1./[0.01; 0.0423; 0.0746; 0.1070; 0.1393; 0.1716; 0.2040; 0.2363; 0.2686; 0.3010; 0.3333; 0.3656; 0.3980; 0.4303; 0.4626; 0.4950];
k = [10 1]; % smoothness of transition between maximal and minimal values of alpha(N), delta(N) and rho(N)

%% here we set the table with input parameter
A1 = A(1)*ones(64,1);  
A2 = A(2)*ones(64,1); 
D1 = D(1)*ones(64,1); 
D2 = D(2)*ones(64,1); 
R1 = R(1)*ones(64,1); 
R2 = R(2)*ones(64,1);
S = Q*ones(64,1); 
Pnu = nu*ones(64,1); 
NbarList = kron(Nbar,ones(1,16))';
Ks = [k(1)*ones(64,1) k(2)*ones(64,1)]; 
aBarNum = repmat(aBar,4,1);

%% table to integrate the combo of parameter to create input parameter set
allPar = [A1 A2 R1 R2 D1 D2 S Pnu Ks NbarList aBarNum];

%% loop to call the function runDynamic which the output are the variables presente in the variable of type cell called auxFi
% To call the function runDynamicF which the output are the matrix to
% create the heatmaps uncomment lines which refer to frames and mtxD and
% comment lines which refer to fi and dataFi

data = zeros(1,size(allPar,2),nrepl); % empty matrix destined to save Fi componets originally from experimental group
% mtxD = cell(nrepl,size(allPar,2));

for traj = 1:nrepl % loop to tensor layer regard trajectories
    % follow the trajectories through command "disp" below 
    % disp(strcat('traj = ',num2str(traj)))
    currcol = 1:toData(1);
    for i = 1:size(allPar,1) % loop to experimental groups
        if (i >= 2)
            currcol = currcol + toData(1); % counter variable to change columns and rows to habour new Fi values
        end
        % follow the experimental group through command "disp" below
        % disp(strcat('i = ',num2str(i)))
        fi = runDynamic(i,n,allPar,toData);
        data(1:size(fi,1),currcol,traj) = fi; % storage of Fi
        % frames = runDynamicF(i,n,allPar,toData);
        % mtxD{traj,i} = frames;
    end
end
save('boxK10K1nu1.mat','data','allPar') % save output file about matrix of data to plot 
% save('frameK1K1nu1.mat','mtxD','allPar') % save output file about matrix
% of data to make heatmap