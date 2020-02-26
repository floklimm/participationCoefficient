function [ D,P ] = participation_matrix( A,C )
%PARTICIPATION_MATRIX Gives the participation vectors for all nodes
%   Input:
%           A - Adjacency matrix (binary, symmetric)
%           C - Community vector (elements are integers, indicating the
%           community each node belongs to. e.g. (1,2,3,1) First and fourth
%           node are in the same community 1.
%   Output:
%           D - degree matrix (number of neighbors for each node into each
%           community)
%           P - participation matrix (scales D by the number of potential neighbours and normalises it)
%
% Florian Klimm Oxford/HU Berlin 2014/15
%
% Klimm, F. et al.: Individual nodeʼs contribution to the mesoscale of complex networks.
% New Journal of Physics, 16(12), 125006.

% number of nodes
n=length(C);

% number of communities
N=max(C);

% size of each community
size_com=histc(C,1:N);

% creating output matrixes
D=NaN(n,N);
P=NaN(n,N);

% going over each node
for i=1:n
    neighbors=find(A(i,:));
    D(i,:)=histc(C(neighbors),1:N);
    %participation vector
    P(i,:)=D(i,:);
    % relative community size of own module has to be decreased by one
    size_com_relativ=size_com;
    % but not if is a single node in the community!
    if size_com_relativ(C(i))>1
        size_com_relativ(C(i))=size_com_relativ(C(i))-1;
    end
    P(i,:)=P(i,:)./size_com_relativ';

    % delete unused communities partitioning
    P(i,isnan(P(i,:)))=0;
    % normalize
    if isempty(find(P(i,:)))
        % if all empty no normalization!
        P(i,:)=P(i,:);
    else
        P(i,:)=P(i,:)/sum(P(i,:));
    end
end








end
