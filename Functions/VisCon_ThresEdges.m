%THRESEDGE Summary of this function goes here
%   Detailed explanation goes here
function VisCon_ThresEdges(Method,MinThres,MaxThres)
global gNetwork;

if nargin<2
    error('Require at least two arguments!');
end

Method=lower(Method);
if strcmp(Method,'proportional')
    if nargin<3,    MaxThres=[];    end
    if ~isempty(MinThres) && ~isempty(MaxThres)
        warning('VisCon:ThresEdges','Maximal threshold will be ignored!');
    end
    if ~isempty(MinThres)
        fprintf('%.2f%% of strongest edges will be retained!\n',MinThres*100);
        if MinThres<0,      MinThres=0; 	end
        if MinThres>1,      MinThres=1;     end
        gNetwork.EdgeRange=[gNetwork.SortedAdj(round((1-MinThres)*(gNetwork.EdgeNum-1))+1),...
            gNetwork.MaxAdj];
    elseif ~isempty(MaxThres)
        fprintf('%.2f%% of weakest edges will be retained!\n',MaxThres*100)
        if MaxThres<0,      MaxThres=0;     end
        if MaxThres>1,      MaxThres=1;     end
        gNetwork.EdgeRange=[gNetwork.MinAdj,...
            gNetwork.SortedAdj(round(MaxThres*(gNetwork.EdgeNum-1))+1)];
    else
        error('Wrong input arguments!');
    end
    caxis(gNetwork.EdgeRange);
    
elseif strcmp(Method,'absolute')
    if nargin<3,                    MaxThres=gNetwork.MaxAdj;    end
    if isempty(MinThres),           MinThres=gNetwork.MinAdj;    end
    if isempty(MaxThres),           MaxThres=gNetwork.MaxAdj;    end
    if MinThres<gNetwork.MinAdj,    MinThres=gNetwork.MinAdj;    end
    if MaxThres>gNetwork.MaxAdj,    MaxThres=gNetwork.MaxAdj;    end
    if MinThres>=MaxThres
        error('Minimal threshold is larger than maximal threshold!');
    end
    fprintf('Edges with weight between %.6f and %.6f will be retained!\n',...
        MinThres,MaxThres);
    gNetwork.EdgeRange=[MinThres,MaxThres];
    caxis(gNetwork.EdgeRange);
else
    error('Wrong input argument!')
end
end
