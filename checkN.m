function nghList = checkN(pickIdx,n)


%% input 
% pickIdx: cell address choosed randomly
% n: number of row and column

%% output
% nghList: list of neighbors address through linear index
N2 = n*n; % total number of cells
auxL = 1:N2; % create a list of linear index
auxIdx = reshape(auxL,n,n); % reshape the linear index list to follow a matirx

bordersL = auxIdx(:,1); % List of the linear index from left borders
bordersT = auxIdx(1,:)'; % List of the linear index from top borders
bordersB = auxIdx(end,:)'; % List of the linear index from bottom borders
bordersR = auxIdx(:,end); % List of the linear index from right borders
borders = [bordersL bordersT bordersB bordersR];% matrix containg the list of borders linears index
cornerIdx = [auxIdx(1) auxIdx(end,1) auxIdx(1,end) auxIdx(end,end)]; % List containg the linear index from the corners


calcNgh = [-n-1 -n -n+1 -1 1 n-1 n n+1]; % auxiliar variable to get neighbors linear index of cells far from borders
bottom = [-n-1 -n -1 n-1 n]; % list auxiliar constant to get neighbors linear index at bottom
left = [-1 1 n-1 n n+1]; % list auxiliar constant to get neighbors linear index at left
right = [-1 1 -n-1 -n -n+1]; % list auxiliar constant to get neighbors linear index at right
top = [-n -n+1 1 n n+1]; % list auxiliar constant to get neighbors linear index at top

nghCTL = [1 n+1 n]; % neighbor linear index at corner top left
nghCBL = [-1 n n-1]; % neighbor linear index at corner bottom left 
nghCTR = [-n -n+1 1]; % neighbor  linear indexat corner top rigth 
nghCBR = [-n -1 -n-1]; % neighbor linear index at corner bottom rigth 


if (intersect(pickIdx,cornerIdx)) % Are the cell choosed on the corners?
    
    if (pickIdx == cornerIdx(1)) % are the cell on the top left?
        
        nghList = pickIdx + nghCTL;
        
    end
    if (pickIdx == cornerIdx(2)) % are the cell on the bottom left?
        
        nghList = pickIdx + nghCBL;
    end
    if (pickIdx == cornerIdx(3)) % are the cell on the top right?
        
        nghList = pickIdx + nghCTR;
    end
    if (pickIdx == cornerIdx(4)) % are the cell on the bottom right?
        
        nghList = pickIdx + nghCBR;
    end
    
elseif (intersect(pickIdx,borders)) % are the cell on the borders?
    
    if (intersect(pickIdx,bordersL)) % are the cell on the left borders?
        
        nghList = pickIdx + left;
    end
    if (intersect(pickIdx,bordersR)) % are the cell on the right borders?
        
        nghList = pickIdx + right;
    end
    if (intersect(pickIdx,bordersT)) % are the cell on the top borders?
        
        nghList = pickIdx + top;
    end
    if (intersect(pickIdx,bordersB)) % are the cell on the bottom borders?
        
        nghList = pickIdx + bottom;
    end
else % are the cell in anywhere?
    nghList = pickIdx + calcNgh;
end

end