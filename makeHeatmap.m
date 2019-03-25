function makeHeatmap(frameFile,dataFile)

%% LOAD data e mtx
% This script is destined to set frames from data file
% This piece of code contain auxiliar variables to set folders which the
% frames will be destined
load(dataFile)
ndata = 15;
ict = 1;
colt = ict:ndata:size(data,2);
tempo = mean(data(:,colt,:),3);
load(frameFile)
map = [1 1 1; 0 1 0;1 0 0];
set(0,'DefaultFigureVisible','off');
% set m = 1:16; m = 17:32; m = 33:48: m = 49:64
for m = 1:16
    for kk = 1:5
        opf = fullfile('Plos Comp Bio','frames','while','NoTime',num2str(allPar(m,8)),...
            strcat('Kp=',num2str(allPar(m,9)),'Km=',num2str(allPar(m,10))),strcat('Nbar',num2str(allPar(m,11)),...
            'aBar',num2str(allPar(m,12))),strcat('traj',num2str(kk)));
        if ~exist(opf,'dir')
            mkdir(opf)
        end
        preD = mtxD{kk,m};
        for jj = 1:size(preD,1)
            
            colormap(map);
            D = cell2mat(preD(jj,1));
            % if you dont want print the time at each figure, just comment what follow below 
            sz = [.25 .5 .4 .4]; % set location
            ttx = {strcat('t = ',num2str(tempo(jj,m)))}; % set text
            phrase = annotation('textbox',sz,'String',ttx,'FitBoxToText','on','EdgeColor',[1 1 1],'FontSize',20); % set further details
            axis equal
            axis tight
            set(gca,'XTickLabel',{''})  % to remove x tick labels
            set(gca,'YTickLabel',{''})  % to remove y tick labels
            set(gca,'XTick',[])         % to remove x ticks
            set(gca,'YTick',[])         % to remove y tiick
            h = imagesc(D,[0 2]); % transform data matrix in image
            set(h,'cdata')
            drawnow
            frame = getframe(gca);
            img = frame2im(frame); % transform image in frame
            [CA,hot] = rgb2ind(img,256); % confer to the image RGB nd indexed featured
            nome = strcat('pic',num2str(jj),'.png');
            imwrite(CA,hot,fullfile(opf,nome),'png'); 
            delete(phrase.Parent.Children); % update into the loop the object responsible to print text inside figure
        end
    end
end

end