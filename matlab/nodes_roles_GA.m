function [ z,pa ] = nodes_roles_GA( A,communities )
%NODES_ROLES_GA Gives the 2d role detection of Guimera and Amaral.


n=size(A,1); % number of nodes
n_com=max(communities); % number of communities
degree=sum(A);

% degree matrix
D=zeros(n,n_com);

for i=1:n
   for j=1:n
       if A(i,j)>0
          D(i,communities(j))=D(i,communities(j))+1; 
       end
   end
end

% for each community the mean internal degree and standad deviation
mean_and_std_internal_degree=zeros(n_com,2);

for i=1:n_com
    nodes_this_com=find(communities==i);
    mean_and_std_internal_degree(i,1)=mean(D(nodes_this_com,i));
    mean_and_std_internal_degree(i,2)=std(D(nodes_this_com,i));
end


% internal degree (with z-score)
z=zeros(n,1);

for i=1:n
   if mean_and_std_internal_degree(communities(i),2)==0
       z(i)=0;
   else
        z(i)= (D(i,communities(i))-mean_and_std_internal_degree(communities(i),1))/mean_and_std_internal_degree(communities(i),2);
   end
end

% participation coefficient
pa=ones(n,1);

for i=1:n
   for j=1:n_com
      pa(i)=pa(i)-(D(i,j)/degree(i))^2; 
   end
end







end

