function [ intra_hubness ] = intra_modular_hubness( D,C )
%INTRA_MODULAR_HUBNESS Gives the intra modular hubness of each node in a network
%   We calculate the intra modular hubness of each node according to a certain partition C of the network. 
%   This defined as the (un)-likellyhood to receive a node of such a degree from a random 
%   ER network with size and number of edges as the module the node belongs
%   to. This function does NOT take the adjacency matrix as an input but the degree matrix D as given by the function participation_matrix) 
%
% Input: Degree matrix D (from function participation_matrix)
%        Partition of network C
% Output: Intra_hubness 
%
% Florian Klimm Oxford/HU Berlin 2014/15



% intra modular degree for each node
[ intra_com_degree ] = intra_degree( D,C );

% n nodes and N communities
[n,N]=size(D);

%initialize
intra_hubness=NaN(n,1);

% we go over each community, and compute the hubness by comparing with ER
% graph statistics
for i=1:N
    nodes_this_community=find(C==i);
    n_this=numel(nodes_this_community);
    
    
    if n_this==1
        intra_hubness(nodes_this_community)=0;
    else
        
        % number of edges in this community
        m=sum(intra_com_degree(nodes_this_community));
    
        % connection density
        density=m/(n_this*(n_this-1));
    
        % mean degree
        mean_degree=n_this*density;
    
        % standard deviation random graph
        std_degree=sqrt(n_this*density*(1-density));

        % hubness
        if std_degree==0
            intra_hubness(nodes_this_community)=0;
        else
            intra_hubness(nodes_this_community)=(intra_com_degree(nodes_this_community)-mean_degree)/std_degree;
        end
    end
end


% % number of nodes
% n=size(A,1);
% 
% % degree
% degree=sum(A);
% 
% % number of nodes
% m=sum(degree);
% 
% % connection density
% density=m/(n*(n-1));
% 
% % mean degree
% mean_degree=n*density;
% 
% % standard deviation random graph
% std_degree=sqrt(n*density*(1-density));
% 
% % hubness
% h=(degree-mean_degree)/std_degree;




end

