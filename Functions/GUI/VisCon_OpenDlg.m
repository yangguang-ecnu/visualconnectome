%VISCON_OPENDLG Summary of this function goes here
%   Detailed explanation goes here
function VisCon_OpenDlg()
[File,Path,Type]=uigetfile({'*.VCT','VisualConnectome File (*.VCT)'},...
    'Open VisualConnectome File');
if Type==1
    try
        VCDataStruct=LoadVisConFile(fullfile(Path,File));
    catch
        errordlg('Load VCT file failed! Invalid or damaged file!',...
            'Open VisualConnectome File');
        return;
    end
    try
        VisualConnectome(VCDataStruct);
    catch
        hFig=findobj('Tag','VisConFig');
        if ~isempty(hFig),  delete(hFig);   end
        VisualConnectome();
        errordlg('Open VCT file failed! Invalid or damaged file!',...
            'Open VisualConnectome File');
        
    end
end
end

