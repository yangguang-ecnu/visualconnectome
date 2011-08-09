%THRESEDGE Summary of this function goes here
%   Detailed explanation goes here
function VisCon_EdgeThres(Method,MinThres,MaxThres)
global gNetwork;
if nargin<2
    error('Require at least two arguments!');
end
%Absolute Threshold
if strcmpi(Method,'absolute')
    if nargin<3,                        
        MaxThres=gNetwork.MaxWeight;    
    end
    if isempty(MinThres),               
        MinThres=gNetwork.MinWeight;    
    end
    if isempty(MaxThres),               
        MaxThres=gNetwork.MaxWeight;    
    end
    if MinThres<gNetwork.MinWeight,     
        MinThres=gNetwork.MinWeight;
        warning('VisCon:EdgeThres',...
            ['Minimal threshold is smaller than minimal weight!\n'...
            'Use %6f instead!'],gNetwork.MinWeight);
    end
    if MaxThres>gNetwork.MaxWeight,     
        MaxThres=gNetwork.MaxWeight;
        warning('VisCon:EdgeThres',...
            ['Maximal threshold is larger than maximal weight!\n'...
            'Use %6f instead!'],gNetwork.MaxWeight);
    end
    if MinThres>MaxThres
        error('Minimal threshold is larger than maximal threshold!');
    end
    fprintf('Edges with weight between %.6f and %.6f will be retained!\n',...
        MinThres,MaxThres);
    gNetwork.EdgeRange=[MinThres,MaxThres];
%Counting Threshold
elseif strcmpi(Method,'counting')
    if nargin>2
        warning('VisCon:EdgeThres',['Require only two arguments!\n'...
           'Maximal threshold will be ignored!']);
    end
    if isempty(MinThres)
        error('Missing minimal threshold, it must be a number ranging from 1 and %i!',...
            gNetwork.NzEdgeNum);
    end
    if MinThres<1      
        MinThres=1;
        warning('VisCon:EdgeThres',['The input argument is smaller than 1.\n'...
            'Use 1 instead!']);
    elseif MinThres>gNetwork.NzEdgeNum
        MinThres=gNetwork.NzEdgeNum;
        warning('VisCon:EdgeThres',['The input argument is larger than'...
            'the number of non-zero edges.\nUse %i instead!'],gNetwork.NzEdgeNum);
    else
        MinThres=round(MinThres);
    end
    MinThres=gNetwork.SortedWeight(gNetwork.NzEdgeNum-MinThres+1);
    Count=sum(gNetwork.SortedWeight>=MinThres);
    fprintf('%i of strongest edges will be retained!\n',Count);
    gNetwork.EdgeRange=[MinThres,gNetwork.MaxWeight];
%Proportional Threshold
elseif strcmpi(Method,'proportional')
    if nargin>2
        warning('VisCon:EdgeThres',['Require only two arguments!\n'...
           'Maximal threshold will be ignored!']);
    end
    if isempty(MinThres)
        error('Missing minimal threshold, it must be a number ranging from 0 and %.2f!',...
            gNetwork.NzEdgeNum/gNetwork.EdgeNum*100);
    end
    MinThres=gNetwork.EdgeNum*MinThres;
    if MinThres<1
        MinThres=1;
        warning('VisCon:EdgeThres',['The input percentage is smaller than %.2f.\n'...
            'Use %.2f instead!'],100/gNetwork.EdgeNum,100/gNetwork.EdgeNum);
    elseif MinThres>gNetwork.NzEdgeNum
        MinThres=gNetwork.NzEdgeNum;
        warning('VisCon:EdgeThres',['The input argument is larger than %.2f.\n'...
            'Use %.2f instead!'],gNetwork.NzEdgeNum/gNetwork.EdgeNum*100,...
            gNetwork.NzEdgeNum/gNetwork.EdgeNum*100);
    else
        MinThres=round(MinThres);
    end
    MinThres=gNetwork.SortedWeight(gNetwork.NzEdgeNum-MinThres+1);
    Count=sum(gNetwork.SortedWeight>=MinThres);
    fprintf('%.2f%% of strongest edges will be retained!\n',Count*100/gNetwork.EdgeNum);
    gNetwork.EdgeRange=[MinThres,gNetwork.MaxWeight];
else
    error('Wrong input argument!')
end
%Update edge colorbar
VisCon_UpdateEdgeCbar()
end
