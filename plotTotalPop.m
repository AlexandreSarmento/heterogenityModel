function [P,r] = plotTotalPop(pop,popS,tempo,kGroup)

% this script make the plot regard to the growth curve over time
% Here we just considered to plot with gompertz curve the groups k1k1, k10k10, k1k10
%% input
% pop: total population average
% popS: total population standar deviation
% tempo: time
% kSgroup: string variable, cotain the name of the experimental group

%% output

% P: population density over time from Gompetz model curve fitting
% r: correlation coefficient between data from simulation and Gompertz
% model

P = zeros(size(pop,1),16*4);
r = zeros(16*4,1);
pars = zeros(1,3); % save parameter from Gompertz model
options = optimset('TolFun',1e-7);
dd = strcmp(kGroup,'k10k1'); % make sure if the data come from k10k1

% Gompertz model curve fitting using lsqcurvefit built-in finction
for n = 1:16*4
    par0 = [1/22500 max(pop(:,n)) 1/10];
    par = lsqcurvefit(@gomCurve,par0,tempo(1:nnz(tempo(:,n)),n),pop(1:nnz(tempo(:,n)),n),[],[],options);
    pars(n,1:3) = [par(1) par(2) par(3)];
end
% Population density from curve fitting using Gompertz model
for nn = 1:16*4
    P(1:nnz(tempo(:,nn)),nn) = pars(nn,2)*exp(log(pars(nn,1)/pars(nn,2))*exp(-pars(nn,3).*tempo(1:nnz(tempo(:,nn)),nn)));
    r(nn) = calcR2(pop(1:nnz(tempo(:,nn)),nn),P(1:nnz(tempo(:,nn)),nn));
end


if (dd == 1)
    
    count = 1;
    for col = 1:16
        
        figure(count)
        hold on
        errorbar(tempo(1:nnz(tempo(:,col)),col),pop(1:nnz(tempo(:,col)),col),popS(1:nnz(tempo(:,col)),col),...
            'ok','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0],'MarkerSize',13);
        
        errorbar(tempo(1:nnz(tempo(:,16+col)),16+col),pop(1:nnz(tempo(:,16+col)),16+col),popS(1:nnz(tempo(:,16+col)),16+col),...
            '^k','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0],'MarkerSize',13);
        
        errorbar(tempo(1:nnz(tempo(:,32+col)),32+col),pop(1:nnz(tempo(:,32+col)),32+col),popS(1:nnz(tempo(:,32+col)),32+col),...
            'sk','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0],'MarkerSize',13);
        
        errorbar(tempo(1:nnz(tempo(:,48+col)),48+col),pop(1:nnz(tempo(:,48+col)),48+col),popS(1:nnz(tempo(:,48+col)),48+col),...
            'pk','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0],'MarkerSize',13);
        hold off
        box on
        axis([0 700 0 max(pop(:,48+col))+0.1])
        hh1 = ylabel('population density');
        hh2 = xlabel('time(A.U)');
        set(hh1,'FontSize',28)
        set(hh2,'FontSize',28)
        xx = get(gca,'XTickLabel');
        set(gca,'XTickLabel',xx,'fontsize',28)
        %         leg = legend(grafico,'$\overline{N} = 1125$','$\overline{N} = 2250$','$\overline{N} = 4500$',...
        %             '$\overline{N} = 6750$','Gompertz');
        %         set(leg,'interpreter','latex','fontsize',32,'orientation','vertical');
        %         set(gcf, 'Position', get(0, 'Screensize'));
        count = count + 1;
    end
else
    grafico = zeros(1,5);
    count = 1;
    for col = 1:16
        
        figure(count)
        hold on
        grafico(1) = errorbar(tempo(1:nnz(tempo(:,col)),col),pop(1:nnz(tempo(:,col)),col),popS(1:nnz(tempo(:,col)),col),...
            'ok','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0],'MarkerSize',13);
        grafico(5) = plot(tempo(1:nnz(tempo(:,col)),col),P(1:nnz(tempo(:,col)),col),'-b','linewidth',2);
        hold on
        grafico(2) = errorbar(tempo(1:nnz(tempo(:,16+col)),16+col),pop(1:nnz(tempo(:,16+col)),16+col),popS(1:nnz(tempo(:,16+col)),16+col),...
            '^k','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0],'MarkerSize',13);
        plot(tempo(1:nnz(tempo(:,16+col)),16+col),P(1:nnz(tempo(:,16+col)),16+col),'-b','linewidth',2)
        hold on
        grafico(3) = errorbar(tempo(1:nnz(tempo(:,32+col)),32+col),pop(1:nnz(tempo(:,32+col)),32+col),popS(1:nnz(tempo(:,32+col)),32+col),...
            'sk','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0],'MarkerSize',13);
        plot(tempo(1:nnz(tempo(:,32+col)),32+col),P(1:nnz(tempo(:,32+col)),32+col),'-b','linewidth',2)
        hold on
        grafico(4) = errorbar(tempo(1:nnz(tempo(:,48+col)),48+col),pop(1:nnz(tempo(:,48+col)),48+col),popS(1:nnz(tempo(:,48+col)),48+col),...
            'pk','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0],'MarkerSize',13);
        plot(tempo(1:nnz(tempo(:,48+col)),48+col),P(1:nnz(tempo(:,48+col)),48+col),'-b','linewidth',2)
        hold off
        hold off
        hold off
        hold off
        box on
        axis([0 700 0 1])
        hh1 = ylabel('population density');
        hh2 = xlabel('time(A.U)');
        set(hh1,'FontSize',28)
        set(hh2,'FontSize',28)
        xx = get(gca,'XTickLabel');
        set(gca,'XTickLabel',xx,'fontsize',28)
        % If legend is necessary, below few line to create legend
        %         leg = legend(grafico,'$\overline{N} = 1125$','$\overline{N} = 2250$','$\overline{N} = 4500$',...
        %             '$\overline{N} = 6750$','Gompertz');
        %         set(leg,'interpreter','latex','fontsize',32,'orientation','vertical');
        %         set(gcf, 'Position', get(0, 'Screensize'));
        count = count + 1;
    end
end
end