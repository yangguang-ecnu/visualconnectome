%LOADVISCONDATA Summary of this function goes here
%   Detailed explanation goes here
function [VCDataStruct] = LoadVisConFile(File, Start)
if nargin == 0
    error('Please input VCT file location!');
end
if nargin == 1
    Start = 1;
end
if ~ischar(File)
    error('File path should be a string');
end
if exist(File,'file')==0
    error('File not found!');
else
    [Path,FileName,Ext] = fileparts(File);
    if Path(end) ~= filesep
        Path(end+1) = filesep;
    end
    VCDataStruct = load(File,'-mat');
    VCDataStruct.VisConFig.FileName = [FileName Ext];
    VCDataStruct.VisConFig.FilePath = Path;
    if Start == 1;
        VisualConnectome(VCDataStruct);
    end
end
end

