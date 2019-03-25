function joinData(listInputFiles)

% This function aim to concatenate of all output file from a family of
% simulation acconding the value of k. Just copy the listOnputFiles
% variable below the loop, and paste in command windows to get the output file to generate graphs.

listOutputFiles = {'dataFiK1K1nu1.mat','dataFiK1K1nu2.mat','dataFiK10K10nu1.mat','dataFiK10K10nu2.mat',...
    'dataFiK10K1nu1.mat','dataFiK10K1nu2.mat','dataFiK1K10nu1.mat','dataFiK1K10nu2.mat'};
count = 1;
for ii = 1:4:numel(listInputFiles)
    
load(listInputFiles{ii})
data1 = dataFi;
load(listInputFiles{ii+1})
data2 = dataFi;
load(listInputFiles{ii+2})
data3 = dataFi;
load(listInputFiles{ii+3})
data4 = dataFi;

rows = [size(data1,1) size(data2,1) size(data3,1) size(data4,1)];
data = zeros(max(rows),size(data1,2)*4,10);

data(1:size(data1,1),1:240,1:10) = data1;
data(1:size(data2,1),241:480,1:10) = data2;
data(1:size(data3,1),481:720,1:10) = data3;
data(1:size(data4,1),721:960,1:10) = data4;

save(listOutputFiles{count},'data','data1','data2','data3','data4')
count = count + 1;

end

% listInputFiles = {
%     'boxk1k1N1nu1.mat','boxk1k1N2nu1.mat','boxk1k1N3nu1.mat','boxk1k1N4nu1.mat',...
%     'boxk1k1N1nu2.mat','boxk1k1N2nu2.mat','boxk1k1N3nu2.mat','boxk1k1N4nu2.mat',...
%     'boxk10k10N1nu1.mat','boxk10k10N2nu1.mat','boxk10k10N3nu1.mat','boxk10k10N4nu1.mat',...
%     'boxk10k1N1nu2.mat','boxk10k10N2nu2.mat','boxk10k10N3nu2.mat','boxk10k10N4nu2.mat',...
%     'boxk10k1N1nu1.mat','boxk10k1N2nu1.mat','boxk10k1N3nu1.mat','boxk10k1N4nu1.mat',...
%     'boxk10k1N1nu2.mat','boxk10k1N2nu2.mat','boxk10k1N3nu2.mat','boxk10k1N4nu2.mat',...
%     'boxk1k10N1nu1.mat','boxk1k10N2nu1.mat','boxk1k10N3nu1.mat','boxk1k10N4nu1.mat',...
%     'boxk1k10N1nu2.mat','boxk1k10N2nu2.mat','boxk1k10N3nu2.mat','boxk1k10N4nu2.mat'
%     };

end