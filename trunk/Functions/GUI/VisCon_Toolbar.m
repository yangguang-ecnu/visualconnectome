%This function sets toolbar property.
function VisCon_Toolbar(Sw)
global gVisConFig;
if nargin<1,    Sw='on';  end
hFig = findobj('Tag','VisConFig');
hVisConTbar = findobj(hFig,'Tag','VisConTbar');
if strcmpi(Sw,'show') || strcmpi(Sw,'on')
    if isempty(hVisConTbar)
        %Create toolbar
        hVisConTbar = uitoolbar(hFig,'Tag','VisConTbar');
        %Create Open Button
        uipushtool('Parent',hVisConTbar,'Tag','VisConTbarOpen','Separator','off',...
            'TooltipString','Open VisualConnectome File','Enable','on',...
            'Separator','off','BusyAction','cancel',...
            'CData',gVisConFig.TbarIcons{1},...
            'ClickedCallback','VisCon_OpenDlg');
        %Create Save As Button
        uipushtool('Parent',hVisConTbar,'Tag','VisConTbarSave','Separator','off',...
            'TooltipString','Save','Enable','off',...
            'Separator','off','BusyAction','cancel',...
            'CData',gVisConFig.TbarIcons{2},...
            'ClickedCallback',@TbarSaveFcn);
        %% Create Toggle Axes Indicator Button
        uitoggletool('Parent',hVisConTbar,'Tag','VisConTbarAxesInd','Separator','on',...
            'TooltipString','Axes Indicator','Enable','off',...
            'BusyAction','cancel',...
            'CData',gVisConFig.TbarIcons{4},...
            'ClickedCallback',@TbarAxesIndFcn);
        %% Create Toggle Edge Colorbar Button
        uitoggletool('Parent',hVisConTbar,'Tag','VisConTbarEdgeCbar','Separator','off',...
            'TooltipString','Edge Colorbar','Enable','off',...
            'BusyAction','cancel',...
            'CData',gVisConFig.TbarIcons{5},...
            'ClickedCallback',@TbarEdgeCbarFcn);
        %% Create Toggle Info. Box Button
        uitoggletool('Parent',hVisConTbar,'Tag','VisConTbarInfoBox','Separator','off',...
            'TooltipString','Info. Box','Enable','off',...
            'BusyAction','cancel',...
            'CData',gVisConFig.TbarIcons{6},...
            'ClickedCallback',@TbarInfoBoxFcn);
        %% Create Subject Picker Button
        uitoggletool('Parent',hVisConTbar,'Tag','VisConTbarSubjPicker','Separator','off',...
            'TooltipString','Subject Picker','Enable','off',...
            'BusyAction','cancel',...
            'CData',gVisConFig.TbarIcons{7},...
            'ClickedCallback',@TbarSubjPickerFcn);
        %% Create Edge Threshold Button
        uipushtool('Parent',hVisConTbar,'Tag','VisConTbarEdgeThres','Separator','on',...
            'TooltipString','Edge Threshold','Enable','off',...
            'BusyAction','cancel',...
            'CData',gVisConFig.TbarIcons{8},...
            'ClickedCallback','VisCon_EdgeThresDlg');
        %% Create Toggle Surface Visibility Button
        uitoggletool('Parent',hVisConTbar,'Tag','VisConTbarSurfVis','Separator','on',...
            'TooltipString','Surface Visibility','Enable','off',...
            'BusyAction','cancel',...
            'CData',gVisConFig.TbarIcons{3},...
            'ClickedCallback',@TbarToggSurfFcn);
    else
        set(hVisConTbar,'Visible','on');
    end
elseif strcmpi(Sw,'off') || strcmpi(Sw,'hide')
    if ~isempty(hVisConTbar)
        set(hVisConTbar,'Visible','off');
    end
else
    error('Wrong input argument!');
end
%Save button function
    function TbarSaveFcn(Src,Evnt)
        if gVisConFig.SaveState == 1
            if isempty(gVisConFig.FilePath)
                VisCon_SaveDlg();
            else
                SaveVisConFile(fullfile(gVisConFig.FilePath, gVisConFig.FileName));
            end
        end
    end
%Axes indicator button function
    function TbarAxesIndFcn(Src,Evnt)
        if strcmp(get(Src,'State'),'off')
            AxesIndicator off;
        elseif strcmp(get(Src,'State'),'on')
            AxesIndicator on;
        end
    end
%Edge colorbar button function
    function TbarEdgeCbarFcn(Src,Evnt)
        if strcmp(get(Src,'State'),'off')
            EdgeColorbar off;
        elseif strcmp(get(Src,'State'),'on')
            EdgeColorbar on;
        end
    end
%Information box button function
    function TbarInfoBoxFcn(Src,Evnt)
        if strcmp(get(Src,'State'),'off')
            InfoBox off;
        elseif strcmp(get(Src,'State'),'on')
            InfoBox on;
        end
    end
%Subject Picker button function
    function TbarSubjPickerFcn(Src,Evnt)
        if strcmp(get(Src,'State'),'off')
            SubjPicker off;
        elseif strcmp(get(Src,'State'),'on')
            SubjPicker on;
        end
    end

%Brain surface button function
    function TbarToggSurfFcn(Src,Evnt)
        if strcmp(get(Src,'State'),'off')
            BrainSurf off;
        elseif strcmp(get(Src,'State'),'on')
            BrainSurf on;
        end
    end
end