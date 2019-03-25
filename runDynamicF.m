function frames = runDynamicF(i,n,allPar,toData)

% Function which run the agent based model. Here we just have as output
% data a matrix of double containing the spatial pattern over time.

L = zeros(n,n); % grid is going to be initially a zeros nxn matrix
L(n/2,n/2) = 1; % place initial variants type 1 in its center

%% parameter input setting
A = [allPar(i,1) allPar(i,2)]; % duplication rates from both variants 1 and 2 respectivelly
R = [allPar(i,3) allPar(i,4)]; % death rates from both variants 1 and 2 respectivelly
D = [allPar(i,5) allPar(i,6)]; % migration rates from both variants 1 and 2 respectivelly
S = allPar(i,7);
nu = allPar(i,8); % generation of variants rates
k = [allPar(i,9) allPar(i,10)]; % k values
Nbar = allPar(i,11);
X = allPar(i,12); % alpha bar ratio

%% setting data storage
frames = cell(1,1); % array of column about grid graph vertices state

%% setting auxiliar variables
dd = 1; % an auxiliary variable into the loop to get state frequency
count1 = 1; % an auxiliar variable to calculate iteration to store datas information
count2 = 1; % an auxiliar variable to calculate iteration to store datas information
Tmax = toData(2); % max iteration number
nframe = toData(3); % ratio of frames per 100.000 thousand iterations
t = 0; % intial time
% pvar = 0;
% calcViz = [-n-1 -n -n+1 -1 1 n-1 n n+1];

while t <= Tmax
    
    idx = find(L); % find a cell
    
    pickIdx = idx(randperm(numel(idx),1)); % get one of the cells at random
    
    nghList = checkN(pickIdx,n); % get the neighbors linear index

    nList0 = nnz(~L(nghList)); % how many empty neighboors?
    
    [alphaN,deltaN,rhoN] = updateRate(A,R,D,L,X,Nbar,k); % call the function which calculate the rates of population dynamic
    % as function of population size
    
    if (nList0 >= 1) % Is there one or more first empty neighboors?
        
        check0 = L(nghList)== 0; % judge the address of empty neighboors
        
        viz0 = nghList(check0 == 1); % get the address of true empty neighboors
        
        probE1 = updateProb(L,pickIdx,alphaN,deltaN,rhoN,S); % call the function which calculates the probabilities
        
        dt = (alphaN(1) + deltaN(1) + rhoN(1) + S)*nnz(L == 1)+(alphaN(2) + deltaN(2) + rhoN(2) + S)*nnz(L == 2); % from
        % rates values calcuated the time increment
        refRand1 = rand;
        
        if (refRand1 < probE1(1)) % What if cells duplicate?
            
            ngh0 = viz0(randperm(numel(viz0),1)); % choose at random one of the empty neighboors
            
            t = t + (1/dt); % if transition occur, increment time
            
            if (L(pickIdx) == 1) % What if the picked cells is number 1?
                
                format long
                
                rr1 = rand;
                
                pvar = 1 - exp(-(nnz(L==1)*nu)/alphaN(1)); % calculate the probability to generate two cells of type 2
                
                if (rr1 < pvar)
                    
                    L(ngh0) = L(pickIdx)+1; % the empty site will be occupied by a cell type 2
                    
                    L(pickIdx) = L(ngh0); % the other daugther cells become a cell type 2
                    
                else % if there is no transformation
                    
                    L(ngh0) = L(pickIdx); % one of the daugther cells goes to an empty place
                    
                    L(pickIdx) = L(pickIdx); % one of the daugther cell belong on the same place of mother cells
                    
                end
                
            else % if the cells is not of type 1
                
                L(ngh0) = L(pickIdx); % one of the daugther cells goes to another place
                
                L(pickIdx) = L(pickIdx); % one of the daugther cell belong on the same place of mother cells
                
            end
            
        elseif (refRand1 < probE1(2))
            
            t = t + (1/dt); % if transition occur, increment time
            
            ngh0 = viz0(randperm(numel(viz0),1)); % choose at random one of the empty neighboors
            
            L(ngh0) = L(pickIdx); % cell goes to another place
            
            L(pickIdx) = 0; % the choosed address become empty
            
        else % cell die
            
            t = t + (1/dt); % if transition occur, increment time
            
            L(pickIdx) = 0;
            
        end
        
    end
    if (nList0 == 0) % if there is no empty first neighboors cells die.
        
        probE0 = updateProb(L,pickIdx,alphaN,deltaN,rhoN,S); % call the function which calculates the probabilities
        
        refRand2 = rand;
        
        if (refRand2 < probE0(1))
            
            t = t + (1/dt); % if transition occur, increment time
            
            L(pickIdx) = L(pickIdx);
            
        else
            
            t = t + (1/dt); % if transition occur, increment time
            
            L(pickIdx) = 0;
            
        end
        
    end
    
    if (count2 == count1) % the field toData must have the value xx changed
        
        frames{dd,1} = L;
        
        kk = floor(log10(count2)); % round th log10 of value niter1
        
        dx = int32((10^(kk+1) - 10^(kk))/nframe); % we shall increment according a ratio nframe dependent
        
        count1 = count1 + round(dx); % increment toData.xx
        
        dd = dd + 1; % as long as xx have a new value we increment a new row on each Fi component
    end
    if (nnz(L) == 0) % once we are working on a sthocastic model eventually initial cells die
        frames{dd,1} = 0;
        break;
    end
    count2 = count2 + 1;
end
end