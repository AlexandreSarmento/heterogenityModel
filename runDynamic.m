function fi = runDynamic(i,n,allPar,toData)

% Function which run the agent based model. Here we just have as output
% data a matrix of double containing the results of population and
% subpopulation densities

L = zeros(n,n); % grid is going to be initially a zeros nxn matrix
L(n/2,n/2) = 1; % place initial variants type 1 in its center

%% parameter input setting
A = [allPar(i,1) allPar(i,2)]; % cell division rates assigned to both proliferative and migratory cells respectivelly
R = [allPar(i,3) allPar(i,4)]; % death rates assigned to both proliferative and migratory cells respectivelly
D = [allPar(i,5) allPar(i,6)]; % migration rates assigned to both proliferative and migratory cells respectivelly
S = allPar(i,7); % quiescence rates assigned to proliferative and migratory cells 
nu = allPar(i,8); % generation of new variants rates
k = [allPar(i,9) allPar(i,10)]; % k values assigend to both proliferative and migratory cells respectivelly
Nbar = allPar(i,11); % population size at which cell division rates falls on half
X = allPar(i,12); % the alpha bar value assigned to both proliferative and migratory variants is calculated as follow 

%% setting data storage
fi = zeros(1,toData(1)); % array of column storing datas to plot

%% setting auxiliar variables
dd = 1; % an auxiliary variable into the loop to get state frequency
count1 = 1; % an auxiliar variable to calculate iteration to store datas information
count2 = 1; % an auxiliar variable to calculate iteration to store datas information
tf = toData(2); % final time
nframe = toData(3); % ratio of frames per 100.000 thousand iterations
t = 0; % intial time
pvar = 0; % inital probaility to generate new variants on domain


while t <= tf
    
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
        
        refRand1 = rand;
        
        dt = (alphaN(1) + deltaN(1) + rhoN(1) + S)*nnz(L == 1)+(alphaN(2) + deltaN(2) + rhoN(2) + S)*nnz(L == 2); % from
        % rates values calcuated the time increment
        
        if (refRand1 < probE1(1)) % What if cells divide?
            
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
            
        elseif (refRand1 < probE1(2)) % What if cells does not divide? Migrate!
            
            t = t + (1/dt); % if transition occur, increment time
            
            ngh0 = viz0(randperm(numel(viz0),1)); % choose at random one of the empty neighboors
            
            L(ngh0) = L(pickIdx); % cell goes to another place
            
            L(pickIdx) = 0; % the choosed address become empty
            
        else % cell die
            
            t = t + (1/dt); % if transition occur, increment time
            
            L(pickIdx) = 0; % the current 
            
        end
        
    end
    if (nList0 == 0) % if there is no empty first neighboors cells die
        
        probE0 = updateProb(L,pickIdx,alphaN,deltaN,rhoN,S); % call the function which calculates the probabilities
        
        refRand2 = rand;
        
        if (refRand2 < probE0(1)) 
            
            t = t + (1/dt); % if transition occur, increment time
            
            L(pickIdx) = L(pickIdx); % the choosed cell address does not change
            
        else
            
            t = t + (1/dt); % if transition occur, increment time
            
            L(pickIdx) = 0; % the choosed cell address become empty
            
        end
        
    end
    
    if (count2 == count1) % the field toData must have the value xx changed
        
        [x,y] = ind2sub(size(L),find(L>0)); % x and y coordinate corresponding to linear index
        
        fi(dd,1) = t; % time
        
        fi(dd,2) = fi(dd,2) + nnz(L == 1)/numel(L); % density of variant 1
        
        fi(dd,3) = fi(dd,3) + nnz(L == 2)/numel(L); % density of variant 2
        
        fi(dd,4) = fi(dd,2) + fi(dd,3); % total density
        
        fi(dd,5) = fi(dd,5) + nnz(~L)/numel(L); % total empty address
        
        fi(dd,6) = pvar; % current probability of generate new variant
        
        fi(dd,7) = alphaN(1); % duplication rate of variants type 1
        
        fi(dd,8) = alphaN(2); % duplication rate of variants type 2
        
        fi(dd,9) = deltaN(1); % migration rate of variants type 1
        
        fi(dd,10) = deltaN(2); % migration rate of variants type 2
        
        fi(dd,11) = rhoN(1); % death rate of variants type 1
        
        fi(dd,12) = rhoN(2); % death rate of variants type 2
        
        fi(dd,13) = sum(x)/nnz(L); % calculate the x vertex occupied to get mass center
        
        fi(dd,14) = sum(y)/nnz(L); % calculate the y vertex occupied to get mass center
        
        fi(dd,15) = dt; % get the increment
  
        kk = floor(log10(count2)); % round th log10 of value niter1
        
        dx = int32((10^(kk+1) - 10^(kk))/nframe); % we shall increment according a ratio nframe dependent
        
        count1 = count1 + round(dx); % increment toData.xx
        
        dd = dd + 1; % as long as xx have a new value we increment a new row on each Fi component
    end
    if (nnz(L) == 0) % once we are working on a sthocastic model eventually initial cells die
        fi(dd,1) = 0; fi(dd,2) = 0; fi(dd,3) = 0;
        fi(dd,4) = 0; fi(dd,13) = 0; fi(dd,14) = 0;
        fi(dd,:) = 0;
        break;
    end
    count2 = count2 + 1; 
end
end