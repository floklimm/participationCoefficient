% compute the roles of nodes

% 1) Load the data
load('./../data/cat.mat')

% create undirected version
A = ceil((CIJall + CIJall')/2);

% % 2) Compute the community structure with GenLouvain
% (comment out if used)
% gamma = 1;
% k = full(sum(A));
% twom = sum(k);
% B = full(A - gamma*k'*k/twom);
% [communities,Q] = genlouvain(B);
% Q = Q/twom

% 2-Alternative) Load other community structure
communities = csvread('./../data/catGraphcommunities.csv');

% 3) Compute the analytical measures
% D and P are the degree and the participation matrix, respectively
[D, P] = participation_matrix(A,communities);
% calculate participation and dispersion
[participationIndex,dispersionIndex] = participation_index(P);
% compute the local hubness (also called intramodular hubness)
local_hub=intra_modular_hubness(D,communities);
% compute the global hubness
hub=hubness(A);

% 4) Plot
% some useful definitions
grayColour=[0.9,0.9,0.9];
fsize=20;


f3=figure('Color',[1 1 1],'Position',[-1500,100,2000,600],'PaperUnits','centimeters','PaperSize',[5,5],'PaperPosition',[0.5 0.5 4 4],'PaperPositionMode','Manual')
% 4a) Participation vs dispersion
subplot(1,3,1)
hold on
scatter(participationIndex,dispersionIndex,'filled')
% forbidden area (below diagonal)
fill([0,1,1],[0,0,1],grayColour)
% other forbidden area
alpha=0:0.01:0.5;
dp_forbidden=1-2*abs(alpha-0.5);
p_forbidden=1-sqrt(3/2*(alpha.^2+(1-alpha).^2 -1/3));
fill([p_forbidden,0],[dp_forbidden,1],grayColour)
line([0,1],[0,1],'Color','k','LineStyle','--')

xlabel('participation p','FontSize',fsize)
ylabel('dispersion d','FontSize',fsize)
annotation('textbox',[0.19,0.3,0.15,0.03],'string','forbidden','BackgroundColor',grayColour,'EdgeColor',grayColour,'FontSize',fsize,'FontName','CMU Serif')

xlim([0,1])
ylim([0,1])
axis square
box on
hold off

% 4b) global hubness vs local hubness
subplot(1,3,2)
scatter(local_hub,hub,'filled')

line([-10,5],[0,0],'Color','k','LineStyle','--')
line([0,0],[-10,15],'Color','k','LineStyle','--')
xlabel('local hubness h^l','FontSize',fsize)
ylabel('global hubness h^g','FontSize',fsize)


axis square
box on

% 4c) Participation vs hubness
subplot(1,3,3)
scatter(participationIndex,hub,'filled')
xlim([0,1])
hold on
line([0,1],[0,0],'Color','k','LineStyle','--')
hold off

xlabel('participation p','FontSize',fsize)
ylabel('global hubness h^g','FontSize',fsize)
axis square
box on


set(findall(gcf,'type','axes'),'fontsize',fsize,'FontName','CMU Serif')
