function [ h ] = hubness( A )
%HUBNESS Gives the hubness of each node in a network
%   For a netwokr defined by the adjacency matrix A we calculate the
%   hubness of each node. This defined as the (un)-likellyhood to receive
%   a node of such a degree from a random ER network.
% Input: Adjacency matrix A
% Output: hubness h (Vector with length = number of nodes)
%
% Florian Klimm Oxford/HU Berlin 2014/15
%
% Klimm, F. et al.: Individual nodeʼs contribution to the mesoscale of complex networks.
% New Journal of Physics, 16(12), 125006.


% number of nodes
n=size(A,1);

% degree
degree=sum(A);

% number of nodes
m=sum(degree);

% connection density
density=m/(n*(n-1));

% mean degree
mean_degree=n*density;

% standard deviation random graph
std_degree=sqrt(n*density*(1-density));

% hubness
h=(degree-mean_degree)/std_degree;




end
