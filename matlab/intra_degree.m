function [ intra_com_degree ] = intra_degree( D,C )
%INTRA_DEGREE Gives the number of neighbors in the nodes on community
%   INPUT:
%           D - degree matrix
%           C - community vector
%   OUTPUT:
%           intra_com_degree - vector with intra community degree for each
%           node
%
% Klimm, F. et al.: Individual nodeʼs contribution to the mesoscale of complex networks.
% New Journal of Physics, 16(12), 125006.

% n nodes and N communities
[n,N]=size(D);

% initialize
intra_com_degree=NaN(n,1);

% go over each node
for i=1:n
   intra_com_degree(i)= D(i,C(i));
end



end
