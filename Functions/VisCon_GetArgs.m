function [varargout] = VisCon_GetArgs(ParaNames,Defaults,varargin)

VarNum=length(varargin);
if mod(VarNum+1,2)==0
    error('The number of arguments must be even!');
end
varargout=Defaults;
ParaNames=lower(ParaNames);

for i=1:2:VarNum
    Pname=varargin{i};
    if ~ischar(Pname)
        error('The %d parameter name is not a string!',(i+1)/2);
    end   
    k=strmatch(lower(Pname),ParaNames,'exact');
    if ~isempty(k)
        varargout{k}=varargin{i+1};
    else
        error('Unknown parameter name: ''%s''!',Pname);
    end
end
end

