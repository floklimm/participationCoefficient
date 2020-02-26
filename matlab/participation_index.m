function [ p,pd ] = participation_index( P )
%participation_index Returns participation index and dispersion
%   Input: 
%           P - Participation matrix from function participation_matrix
%   Output:
%           p  - participation index
%           pd - dispersion index (a node centric version of participation)
%
% Florian Klimm Oxford/HU Berlin 2014/15

% n nodes and N communities
[n,N]=size(P);

% initialze output
p=NaN(n,1);
pd=NaN(n,1);

% go over each node

if N==1
    % only a single community return participation of one for each node
    p=zeros(n,1);
    pd=zeros(n,1);
else
    prefactor=N/sqrt(N-1);

    for i=1:n
        % normal participation index
        if any([isnan(std(P(i,:),1)),sum(P(i,:))==0])
            %if isolated node
                p(i)=0;
        else
            p(i)=1-prefactor*std(P(i,:),1);
        end
        % node centric dispersion
    
        connected_com=find(P(i,:));
        % number connected communities
        N_prime=length(connected_com);
        
        if N_prime==1
            pd(i)=0;
        elseif N_prime==0
            pd(i)=0;
        else
            pd(i)=1-(N_prime/sqrt(N_prime-1))*std(P(i,connected_com),1);
        end
    
    end
end



end

