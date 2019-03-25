function plotSubPop(dataA,dataB)

% this function plots graphs referring to subpopulation evolution
load(dataA); % load the data referring to $\nu = 10^{-7}$
[pop,pop1,pop2,popS,tempo] = calcPopDens(data); % calculte the average densities
popT1 = pop;
pop1_1 = pop1;
pop2_1 = pop2;
popS1 = popS;
tempo1 = tempo;

load(dataB); % load the data referring to $\nu = 10^{-7}$
[pop,pop1,pop2,popS,tempo] = calcPopDens(data); % calculte the average densities
popT2 = pop;
pop1_2 = pop1;
pop2_2 = pop2;
popS2 = popS;
tempo2 = tempo;
count = 1;

grafs4 = zeros(1,6);
for col = 1:16*4
    
    figure(count)
    hold on
    grafs4(3) = plot(tempo1(1:nnz(tempo1(:,col)),col),pop1_1(1:nnz(tempo1(:,col)),col),'-^','MarkerFaceColor',[0 1 0],...
        'MarkerEdgeColor',[0 0 0],'MarkerSize',13);
    hold on
    grafs4(4) = plot(tempo1(1:nnz(tempo1(:,col)),col),pop2_1(1:nnz(tempo1(:,col)),col),'-^','MarkerFaceColor',[1 0 0],...
        'MarkerEdgeColor',[0 0 0],'MarkerSize',13);
    hold on
    grafs4(1) = errorbar(tempo1(1:nnz(tempo1(:,col)),col),popT1(1:nnz(tempo1(:,col)),col),popS1(1:nnz(tempo1(:,col)),col),...
        ':^k','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0],'MarkerSize',13);
    hold on
    grafs4(5) = plot(tempo2(1:nnz(tempo2(:,col)),col),pop1_2(1:nnz(tempo2(:,col)),col),'-o','MarkerFaceColor',[0 1 0],...
        'MarkerEdgeColor',[0 0 0],'MarkerSize',13);
    hold on
    grafs4(6) = plot(tempo2(1:nnz(tempo2(:,col)),col),pop2_2(1:nnz(tempo(:,col)),col),'-o','MarkerFaceColor',[1 0 0],...
        'MarkerEdgeColor',[0 0 0],'MarkerSize',13);
    hold on
    grafs4(2) = errorbar(tempo2(1:nnz(tempo2(:,col)),col),popT2(1:nnz(tempo(:,col)),col),popS2(1:nnz(tempo(:,col)),col),...
        ':ok','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0],'MarkerSize',13);
    hold off
    hold off
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
    set(gcf, 'Position', get(0, 'Screensize'));
    count = count + 1;
end

end

