% small example network with all possible roles of nodes

recreate=1;
    
if recreate==1
    % 1) Create the graph
    n=47; % number of nodes

    A=zeros(n); % adjacency matrix
    
    % now we create 4 communities of size 10 with different connection
% probabilities
% additionally each community gets a hald connected 'hub' (degree 5)
% 1 - density=0.75
prob=0.45;
for i=1:10
   for j=(i+1):10
      if rand<prob 
            A(i,j)=1; 
      end
   end
end
A(11,[1:5])=1;


% 2 - density=0.5
prob=0.3;
for i=12:21
   for j=(i+1):21
      if rand<prob 
            A(i,j)=1; 
      end
   end
end
A(22,12:16)=1;


% 3 - density=0.5 (twice the size)
prob=0.3;
for i=23:42
   for j=(i+1):42
      if rand<prob 
            A(i,j)=1; 
      end
   end
end
%A(33,23:27)=1;

% % 4 - density=0.25
% prob=0.25;
% for i=34:43
%    for j=(i+1):43
%         if rand<prob 
%                 A(i,j)=1; 
%         end
%        end
% end
A(43,23:34)=1;    
    
% create a global hub between 2 communities
A(44,[1,2,3,4,5,6])=1; % com 1
A(44,[12,13,14,15,16,17])=1; % com 2

% create a global hub between all 4 communities
A(45,[1,5,9])=1; % com 1
A(45,[12,15,18])=1; % com 2
A(45,[23,26,29,31,33,37])=1; % com 3
%A(46,[34,37,40])=1; % com 4
    

% create a non-hub between all 3 communities
A(46,[10,21,32])=1;
% create a non-hub between 2 communities
%A(48,[9,11,20,22])=1;
A(47,[10,41,42])=1;

plotnodenumber=zeros(n,1);
plotnodenumber([11,22,43,44,45,46,47])=1;

    % symmetrize and create sparse matrix
    A=A+A';
    sparseA=sparse(A);

    
    [xy] = fruc_rein(A,0.999, rand);
    
    
    
    % 2) community detection


k = full(sum(sparseA)); % degree of the network
twom = sum(k);  % number of edges (double counted)

gamma=0.8;

B = @(v) sparseA(:,v) - gamma*k'*k(v)/twom; %creating the pointer 
communities=0;
while max(communities)~=3
    [communities,Q] = genlouvain(B); % running the Louivain algorithm
end
Q = Q/twom; % rescaling the modularity
    
    %save example_graph.mat
else
    % load it
    %load example_graph.mat
    
end



% 3) Calculation of the analytics

[D, P] = participation_matrix(A,communities);
[p,pd] = participation_index(P);
    
%[withoutnorm] = intra_modular_hubness(A,communities);
i_hub=intra_modular_hubness(D,communities);
hub=hubness(A);

[ z,pa ] = nodes_roles_GA( A,communities );

% svd
[U,S,V] = svd(D);




% 4) Plotting
fsize=35;

% do the coloring
guardsman_red=[204/255,0,0];
black=[0,0,0];
orange_yellow=[18/255,151/255,147/255];
%orange_yellow=[0,0,0];
violet_blue=[102/255,0,204/255];
gray=[0.9,0.9,0.9];
cmap=[gray;black;guardsman_red;orange_yellow;violet_blue];

% write the Adjacency matrix for coloring the edges
Ac=zeros(size(A));
for i=1:n
    for j=i:n
        % if there is an edge
        if(A(i,j))==1
           % if they are in the same community
           if (communities(i)==communities(j))
                Ac(i,j)=communities(i)+1;
                
           else
                % if not a blakc edge
                Ac(i,j)=1;
                
           end
            
        end
    end
end
Ac=Ac+Ac';

colorvec=zeros(n,3);

for i=1:n
   colorvec(i,:)= cmap(communities(i)+2,:);
end
ncom=max(communities);

% %a) Adjacency matrix
% 
% 
% f1=figure('Color',[1,1,1],'Position',[-1500,100,1000,1000],'PaperUnits','centimeters','PaperSize',[5,5],'PaperPosition',[0.5 0.5 4 4],'PaperPositionMode','Manual');
% imagesc(Ac)
% axis square
% %title('Adjacency matrix','interpreter','latex','FontSize',fsize)
% caxis([0,4])
% set(gca,'YAxisLocation','left','YTick',[10,20,30,40],'XTick',[10,20,30,40])
% box on
% cmap=colormap(cmap);
% set(findall(gcf,'type','axes'),'fontsize',fsize,'FontName','CMU Serif')
% axis square





%b) nodes at positions with the communities

% f2=figure('Color',[1 1 1],'Position',[-1500,100,1000,800],'PaperUnits','centimeters','PaperSize',[5,5],'PaperPosition',[0.5 0.5 4 4],'PaperPositionMode','Manual')
% hold on
% for i=1:n
%    for j=(i+1):n
%       if A(i,j)>0
%           line([xy(i,1),xy(j,1)],[xy(i,2),xy(j,2)],'Color',zeros(3,1),'LineWidth',1.5)
%           
%       end
%    end
% end
% 
% %scatter(xy(:,1),xy(:,2),50,communities+1,'fill')
% 
% 
% 
% for i=1:n
%     if communities(i)==1
%         scatter(xy(i,1),xy(i,2),400,communities(i)+1,'fill')
%     elseif communities(i)==2
%         scatter(xy(i,1),xy(i,2),400,communities(i)+1,'fill','d')
%     elseif communities(i)==3
%         scatter(xy(i,1),xy(i,2),400,communities(i)+1,'fill','>')
%     end
% end
% 
% 
% 
% 
% colormap(cmap)
% caxis([0,4])
% axis off
% 
% % nodes indexes
% for i=1:n
%     if plotnodenumber(i)==1
%          if i==43
%              text(xy(i,1)-0.5,xy(i,2)-0.2,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize)
%              %annotation('arrow',[xy(i,1)-0.5,xy(i,1)],[xy(i,2)-0.2,xy(i,2)],'LineColor','r')
%          elseif i==22
%              text(xy(i,1),xy(i,2)-0.2,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize)
%          elseif i==47
%              text(xy(i,1)+0.1,xy(i,2),num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize)
%          elseif i==44
%              text(xy(i,1)+0.1,xy(i,2)-0.15,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize)
%          elseif i==45
%              text(xy(i,1)+0.1,xy(i,2)+0.15,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize)
%          elseif i==46
%              text(xy(i,1)-0.35,xy(i,2)-0.05,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize)
%          else
%             text(xy(i,1)+0.02,xy(i,2)+0.02,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize)
%         end
%     end
% end
% hold off
%title('Force-directed placement','interpreter','latex','FontSize',fsize)


% % c) The four combinations we are interested in (h,p),(h,hi),(dp,p),(dp,h)
% 

% % h vs ih
% 
% 
% limitshub=[floor(min(hub)),ceil(max(hub))];
% limitsihub=[floor(min(i_hub)),ceil(max(i_hub))];
% 
% f3=figure('Color',[1 1 1],'Position',[-1500,100,1000,1000],'PaperUnits','centimeters','PaperSize',[5,5],'PaperPosition',[0.5 0.5 4 4],'PaperPositionMode','Manual')
% hold on
% line([0,0],[-10,10],'Color','k')
% line([-10,10],[0,0],'Color','k')
% line([-10,10],[-10,10],'Color','k')
% line([-10,10],[2.5,2.5],'Color','k','LineStyle','--')
% for i=1:n
%     if communities(i)==1
%         scatter(i_hub(i),hub(i),400,communities(i)+1,'fill')
%     elseif communities(i)==2
%         scatter(i_hub(i),hub(i),400,communities(i)+1,'fill','d')
%     elseif communities(i)==3
%         scatter(i_hub(i),hub(i),400,communities(i)+1,'fill','>')
%     end
% end
% hold off
% 
% xlabel('local hubness $h^l$','FontSize',fsize)
% ylabel('global hubness $h^g$','FontSize',fsize)
% for i=1:n
%     if plotnodenumber(i)==1
%         text(i_hub(i)+0.1,hub(i)+0.0,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize) 
%     end
% end
% text(1.5,1.4,'$h^l=h^g$','Color','k','interpreter','latex','Fontsize',fsize) 
% set(findall(gcf,'type','axes'),'fontsize',fsize,'FontName','CMU Serif')
% colormap(cmap)
% caxis([0,4])
% 
% xlim(limitsihub)
% ylim(limitshub)
% axis square
% box on







% % %% h vs p
% f3=figure('Color',[1 1 1],'Position',[-1500,100,1000,1000],'PaperUnits','centimeters','PaperSize',[5,5],'PaperPosition',[0.5 0.5 4 4],'PaperPositionMode','Manual')
% hold on
% line([0,1],[0,0],'Color','k')
% line([0,1],[2.5,2.5],'Color','k','LineStyle','--')
% for i=1:n
%     if communities(i)==1
%         scatter(p(i),hub(i),400,communities(i)+1,'fill')
%     elseif communities(i)==2
%         scatter(p(i),hub(i),400,communities(i)+1,'fill','d')
%     elseif communities(i)==3
%         scatter(p(i),hub(i),400,communities(i)+1,'fill','>')
%     end
% end
% 
% hold off
% 
% 
% colormap(cmap)
% caxis([0,4])
% 
% 
% 
% xlabel('participation $p$','FontSize',fsize)
% ylabel('global hubness $h^g$','FontSize',fsize)
% for i=1:n
%     if plotnodenumber(i)==1
%         if i==43
%             text(p(i)+0.025,hub(i)-0.3,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize)
%         elseif i==11
%             text(p(i)+0.025,hub(i)+0.3,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize)
%         elseif i==47
%             text(p(i),hub(i)-0.3,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize)    
%         else
%             text(p(i)+0.025,hub(i),num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize) 
%     
%         end
%     end
% end
% xlim([0,1])
% ylim(limitshub)
% axis square
% set(findall(gcf,'type','axes'),'fontsize',fsize,'FontName','CMU Serif')
% box on

% % hubness vs. dispersion
% 
% f3=figure('Color',[1 1 1],'Position',[-1500,100,1000,1000],'PaperUnits','centimeters','PaperSize',[5,5],'PaperPosition',[0.5 0.5 4 4],'PaperPositionMode','Manual')
% %scatter(pd,hub,20,colorvec,'fill')
% hold on 
% line([0,1],[0,0],'Color','k')
% line([0,1],[2.5,2.5],'Color','k','LineStyle','--')
% for i=1:n
%     if communities(i)==1
%         scatter(pd(i),hub(i),400,communities(i)+1,'fill')
%     elseif communities(i)==2
%         scatter(pd(i),hub(i),400,communities(i)+1,'fill','d')
%     elseif communities(i)==3
%         scatter(pd(i),hub(i),400,communities(i)+1,'fill','>')
%     end
% end
% 
% 
% xlabel('dispersion $d$','FontSize',fsize)
% ylabel('global hubness $h^g$','FontSize',fsize)
% 
% for i=1:n
%     if plotnodenumber(i)==1
%         if i==45
%             text(pd(i)-0.05,hub(i)+0.3,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize) 
%         elseif i==44
%             text(pd(i)-0.08,hub(i)-0.3,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize) 
%         elseif i==11
%             text(pd(i)+0.02,hub(i)+0.15,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize)
%         elseif i==22
%             text(pd(i)+0.02,hub(i)-0.15,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize)    
%         else
%             text(pd(i)+0.02,hub(i),num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize) 
%         end
%     end
% end
% xlim([0,1])
% ylim(limitshub)
% colormap(cmap)
% caxis([0,4])
% set(findall(gcf,'type','axes'),'fontsize',fsize,'FontName','CMU Serif')
% 
% box on
% axis square

% participation vs. dispersion
f3=figure('Color',[1 1 1],'Position',[-1500,100,1000,1000],'PaperUnits','centimeters','PaperSize',[5,5],'PaperPosition',[0.5 0.5 4 4],'PaperPositionMode','Manual')
hold on
% forbidden area (below diagonal)
fill([0,1,1],[0,0,1],gray)

% other forbidden area
alpha=0:0.01:0.5;
dp_forbidden=1-2*abs(alpha-0.5);
p_forbidden=1-sqrt(3/2*(alpha.^2+(1-alpha).^2 -1/3));
fill([p_forbidden,0],[dp_forbidden,1],gray)

%dp_lim=0:0.01:1;
%alpha2=(2-dp_lim)/2;
%p_lim=1-sqrt(3/2*(alpha2.^2+(1-alpha2).^2 -1/3));

line([0,1],[0,1],'Color','k','LineStyle','--')
for i=1:n
    if communities(i)==1
        scatter(p(i),pd(i),400,communities(i)+1,'fill')
    elseif communities(i)==2
        scatter(p(i),pd(i),400,communities(i)+1,'fill','d')
    elseif communities(i)==3
        scatter(p(i),pd(i),400,communities(i)+1,'fill','>')
    end
end

%plot(p_lim,dp_lim,'b')
hold off

colormap(cmap)
caxis([0,4])

%scatter(p,pd,20,colorvec,'fill')

xlabel('participation $p$','FontSize',fsize)
ylabel('dispersion $d$','FontSize',fsize)
annotation('textbox',[0.6,0.3,0.15,0.03],'string','forbidden','BackgroundColor',gray,'EdgeColor',gray,'FontSize',fsize,'HorizontalAlignment','center')


for i=1:n
    if plotnodenumber(i)==1
        if i==11
            text(p(i)+0.02,pd(i)+0.04,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize)
        elseif i==22
            text(p(i)+0.09,pd(i)+0.04,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize)
        elseif i==43
            text(p(i)+0.16,pd(i)+0.04,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize)
            
        else
        
            text(p(i),pd(i)-0.04,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize) 
        end
    end
end
xlim([0,1])
ylim([0,1])
%text(0.53,0.47,'$p=dp$','Color','k','interpreter','latex','Fontsize',fsize)
%annotation('textarrow',[0.53,0.47,0.1,0.1],'string','$p=dp$','interpreter','latex','Fontsize',fsize,'BackgroundColor',gray,'EdgeColor',gray)
annotation('textarrow',[0.7,0.65],[0.5,0.6],'LineWidth',1.5,'string','$p=d$','interpreter','latex','Fontsize',fsize)
annotation('textarrow',[0.47,0.53],[0.7,0.77],'LineWidth',1.5,'string','$\max\{p(d)\}$','interpreter','latex','Fontsize',fsize)
axis square
set(findall(gcf,'type','axes'),'fontsize',fsize,'FontName','CMU Serif')
box on



% d) GA


f3=figure('Color',[1 1 1],'Position',[-1500,100,1000,1000],'PaperUnits','centimeters','PaperSize',[5,5],'PaperPosition',[0.5 0.5 4 4],'PaperPositionMode','Manual')
hold on
fill([2/3,1-0.001,1-0.001,2/3],[-2.5+0.01,-2.5+0.01,3-0.01,3-0.01],gray,'EdgeColor',gray)
line([0,2/3],[0,0],'Color','k','LineStyle','--')
line([0,2/3],[2.5,2.5],'Color','k','LineStyle','--')
line([0.02,0.02],[-10,10],'Color','k')
line([0.62,0.62],[-10,10],'Color','k')
line([0.8,0.8],[-10,10],'Color','k')
 for i=1:n
    if communities(i)==1
        scatter(pa(i),z(i),400,communities(i)+1,'fill')
    elseif communities(i)==2
        scatter(pa(i),z(i),400,communities(i)+1,'fill','d')
    elseif communities(i)==3
        scatter(pa(i),z(i),400,communities(i)+1,'fill','>')
    end
 end
%quiver(0.05,-2,-0.04,+0.2,'k','LineWidth',1.5)
hold off

colormap(cmap)
caxis([0,4])

% scatter(pa,z,20,colorvec,'fill')

set(gca,'XTick',[0,0.62,0.8,1])
xlim([-0.02,1])
ylim([-2.5,3])
xlabel('participation')
ylabel('z-score internal degree')
for i=1:n
    if plotnodenumber(i)==1
        text(pa(i)+0.03,z(i),num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',25) 
    end
end
axis square
set(findall(gcf,'type','axes'),'fontsize',fsize,'FontName','CMU Serif')
box on

% labels for the roles
annotation('arrow',[0.3,0.27],[0.26,0.3],'LineWidth',1.5)
text(0.05,-2,'R1','interpreter','latex','Fontsize',fsize)
text(0.31,-2,'R2','interpreter','latex','Fontsize',fsize)
text(0.7,-2,'R3','interpreter','latex','Fontsize',fsize)
text(0.9,-2,'R4','interpreter','latex','Fontsize',fsize)
%text(0.07,1.5,'no $z>2.5$','interpreter','latex','Fontsize',fsize)
annotation('textarrow',[0.48,0.48],[0.75,0.8],'LineWidth',1.5,'string','hubs $z>2.5$','interpreter','latex','Fontsize',fsize)
annotation('textbox',[0.72,0.57,0.15,0.03],'string','forbidden','BackgroundColor',gray,'EdgeColor',gray,'FontSize',fsize,'HorizontalAlignment','center')
%annotation('textbox',[0.4,0,0.15,0.03],'string','no $z>2.5$','interpreter','latex','Fontsize',fsize)

title('Functional roles framework','interpreter','latex','Fontsize',25)


% e) SVD

% projection
% get the 2 major directions
U1=sign(U(1,1))*U(:,1);
U2=U(:,2);
% get the summed vectors for each community
m1=zeros(2,1);
m2=zeros(2,1);
m3=zeros(2,1);
for i=1:n % go over each node
    if communities(i)==1
        % x value summed up
        m1(1)=m1(1)+U1(i);
        % y value summed up
        m1(2)=m1(2)+U2(i);
    elseif communities(i)==2
        % x value summed up
        m2(1)=m2(1)+U1(i);
        % y value summed up
        m2(2)=m2(2)+U2(i);
    elseif communities(i)==3
        % x value summed up
        m3(1)=m3(1)+U1(i);
        % y value summed up
        m3(2)=m3(2)+U2(i);
    end
    
end



f9=figure('Color',[1 1 1],'Position',[-1500,100,1000,1000],'PaperUnits','centimeters','PaperSize',[5,5],'PaperPosition',[0.5 0.5 4 4],'PaperPositionMode','Manual');



hold on

% line of x=0
line([0,0],[-1,+1],'Color','k')
% lines for the communities (internal)
line([0,10*U1(11)],[0,10*U2(11)],'Color',cmap(3,:),'LineWidth',2,'LineStyle','-')
line([0,10*U1(22)],[0,10*U2(22)],'Color',cmap(4,:),'LineWidth',2,'LineStyle','-')
line([0,10*U1(43)],[0,10*U2(43)],'Color',cmap(5,:),'LineWidth',2,'LineStyle','-')

% summed line
line([0,10*m1(1)],[0,10*m1(2)],'Color',cmap(3,:),'LineWidth',2,'LineStyle',':')
line([0,10*m2(1)],[0,10*m2(2)],'Color',cmap(4,:),'LineWidth',2,'LineStyle',':')
line([0,10*m3(1)],[0,10*m3(2)],'Color',cmap(5,:),'LineWidth',2,'LineStyle',':')

for i=1:n
    if communities(i)==1
        scatter(U1(i),U2(i),400,communities(i)+1,'fill')
    elseif communities(i)==2
        scatter(U1(i),U2(i),400,communities(i)+1,'fill','d')
    elseif communities(i)==3
        scatter(U1(i),U2(i),400,communities(i)+1,'fill','>')
    end
 end


colormap(cmap)
caxis([0,4])

%scatter(U1,U2,40,colorvec,'fill')

xlabel('$U_1$','Fontsize',fsize)
ylabel('$U_2$','Fontsize',fsize)
for i=1:n
    if plotnodenumber(i)==1
        if i==43
            text(U1(i)+0.015,U2(i)+0.02,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize)
        else
            text(U1(i)+0.015,U2(i),num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',fsize) 
        end
    end
end
xlim([0,max(U1)+0.1])
ylim([min(U2)-0.1,max(U2)+0.1])
hold off
axis square
box on
title('SVD of contribution matrix $\mathbf{C}$','interpreter','latex','Fontsize',25)
set(findall(gcf,'type','axes'),'fontsize',fsize,'FontName','CMU Serif')





%%%%%%%%%%%%%




% 
% 
% limitshub=[floor(min(hub)),ceil(max(hub))];
% limitsihub=[floor(min(i_hub)),ceil(max(i_hub))];
% 
% %b) different combinations of various analytics
% f3=figure()
% scatter(i_hub,hub,20,colorvec,'fill')
% line([0,0],[-10,10],'Color','k')
% line([-10,10],[0,0],'Color','k')
% line([-10,10],[-10,10],'Color','k')
% xlabel('internal hubness')
% ylabel('hubness')
% for i=1:n
%     if plotnodenumber(i)==1
%    text(i_hub(i)+0.4*rand-0.2,hub(i)+0.4*rand-0.2,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',25) 
%     end
% end
% 
% xlim(limitsihub)
% ylim(limitshub)
% 
% f4=figure()
% scatter(pd,hub,20,colorvec,'fill')
% line([0,1],[0,0],'Color','k')
% xlabel('dispersion')
% ylabel('hubness')
% for i=1:n
%     if plotnodenumber(i)==1
%    text(pd(i),hub(i)+0.4*rand-0.2,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',25) 
%     end
% end
% xlim([0,1])
% ylim(limitshub)
% 
% f5=figure()
% scatter(p,hub,20,colorvec,'fill')
% line([0,1],[0,0],'Color','k')
% xlabel('participation')
% ylabel('hubness')
% for i=1:n
%     if plotnodenumber(i)==1
%    text(p(i),hub(i)+0.4*rand-0.2,num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',25) 
%     end
% end
% xlim([0,1])
% ylim(limitshub)
% 
% f6=figure()
% scatter(p,pd,20,colorvec,'fill')
% line([0,1],[0,0],'Color','k')
% xlabel('participation')
% ylabel('dispersion')
% for i=1:n
%     if plotnodenumber(i)==1
%    text(p(i),pd(i),num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',25) 
%     end
% end
% xlim([0,1])
% ylim([0,1])
% 
% f7=figure()
% scatter(pd,i_hub,20,colorvec,'fill')
% line([0,1],[0,0],'Color','k')
% xlabel('dispersion')
% ylabel('internal hubness')
% for i=1:n
%     if plotnodenumber(i)==1
%    text(pd(i),i_hub(i),num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',25) 
%     end
% end
% xlim([0,1])
% ylim(limitsihub)
% 
% f7=figure()
% scatter(p,i_hub,20,colorvec,'fill')
% line([0,1],[0,0],'Color','k')
% xlabel('participation')
% ylabel('internal hubness')
% for i=1:n
%     if plotnodenumber(i)==1
%    text(p(i),i_hub(i),num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',25) 
%     end
% end
% xlim([0,1])
% ylim(limitsihub)
% 
% 
% 
% f8=figure()
% scatter(pa,z,20,colorvec,'fill')
% line([0,1],[0,0],'Color','k')
% xlabel('participation (by GA)')
% ylabel('z-score internal degree (by GA)')
% for i=1:n
%     if plotnodenumber(i)==1
%    text(pa(i),z(i),num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',25) 
%     end
% end
% 
% % projection
% % get the 2 major directions
% U1=sign(U(1,1))*U(:,1);
% U2=U(:,2);
% % get the summed vectors for each community
% m1=zeros(2,1);
% m2=zeros(2,1);
% m3=zeros(2,1);
% for i=1:n % go over each node
%     if communities(i)==1
%         % x value summed up
%         m1(1)=m1(1)+U1(i);
%         % y value summed up
%         m1(2)=m1(2)+U2(i);
%     elseif communities(i)==2
%         % x value summed up
%         m2(1)=m2(1)+U1(i);
%         % y value summed up
%         m2(2)=m2(2)+U2(i);
%     elseif communities(i)==3
%         % x value summed up
%         m3(1)=m3(1)+U1(i);
%         % y value summed up
%         m3(2)=m3(2)+U2(i);
%     end
%     
% end
% 
% 
% 
% f9=figure()
% 
% 
% 
% hold on
% 
% % line of x=0
% line([0,0],[-1,+1],'Color','k')
% % lines for the communities (internal)
% line([0,10*U1(11)],[0,10*U2(11)],'Color',cmap(3,:),'LineWidth',2,'LineStyle','--')
% line([0,10*U1(22)],[0,10*U2(22)],'Color',cmap(4,:),'LineWidth',2,'LineStyle','--')
% line([0,10*U1(43)],[0,10*U2(43)],'Color',cmap(5,:),'LineWidth',2,'LineStyle','--')
% 
% % summed line
% line([0,10*m1(1)],[0,10*m1(2)],'Color',cmap(3,:),'LineWidth',2,'LineStyle',':')
% line([0,10*m2(1)],[0,10*m2(2)],'Color',cmap(4,:),'LineWidth',2,'LineStyle',':')
% line([0,10*m3(1)],[0,10*m3(2)],'Color',cmap(5,:),'LineWidth',2,'LineStyle',':')
% 
% scatter(U1,U2,40,colorvec,'fill')
% 
% xlabel('U(1)')
% ylabel('U(2)')
% for i=1:n
%     if plotnodenumber(i)==1
%    text(U1(i),U2(i),num2str(i),'Color',colorvec(i,:),'interpreter','latex','Fontsize',25) 
%     end
% end
% xlim([0,max(U1)+0.1])
% ylim([min(U2)-0.1,max(U2)+0.1])
% hold off

