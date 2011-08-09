function [ Type ] = VisCon_SaveDlg()
[File,Path,Type] = uiputfile(...
    {'*.VCT','VisualConnectome File (*.VCT)'},...
    'Save As ...','Untitled');
if ~isequal(File,0) && ~isequal(Path,0) && ~isequal(Type,0)
    try
        SaveVisConFile(fullfile(Path,File));
    catch Error
        errordlg('Error occurred while saving VCT file!',...
            'VisualConnectome');
        assignin('base', 'VisConError', Error);
        throw(Error);
    end
end
end

