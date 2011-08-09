%LOADVISCONDATA Summary of this function goes here
%   Detailed explanation goes here
function [VCDataStruct]=LoadVisConFile(File)
if nargin>0
    if ~ischar(File)
        error('File path should be a string');
    end
    if exist(File,'file')==0
        error('File not found!');
    else
        VCDataStruct=load(File,'-mat');
    end
else
    error('Please enter file location!');
end
end

