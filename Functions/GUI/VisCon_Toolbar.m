%This function sets toolbar property.
function VisCon_Toolbar(Sw)
global gFigAxes;
if nargin<1,    Sw='on';  end
hFig=findobj('Tag','VisConFig');
hVisConTbar=findobj(hFig,'Tag','VisConTbar');
if strcmpi(Sw,'show') || strcmpi(Sw,'on')
    if isempty(hVisConTbar)
        %Create toolbar
        hVisConTbar=uitoolbar(hFig,'Tag','VisConTbar');
        %Create Open Button
        uipushtool('Parent',hVisConTbar,'Tag','VisConTbarOpen','Separator','off',...
            'TooltipString','Open VisualConnectome File','Enable','on',...
            'Separator','off','BusyAction','cancel','Interruptible','off',...
            'CData',gFigAxes.TbarIcons{1},...
            'ClickedCallback','VisCon_OpenDlg');
        %Create Save As Button
        uipushtool('Parent',hVisConTbar,'Tag','VisConTbarSave','Separator','off',...
            'TooltipString','Save As...','Enable','off',...
            'Separator','off','BusyAction','cancel','Interruptible','off',...
            'CData',gFigAxes.TbarIcons{2},...
            'ClickedCallback','VisCon_SaveDlg');
        %% Create Toggle Axes Indicator Button
        uitoggletool('Parent',hVisConTbar,'Tag','VisConTbarAxesInd','Separator','on',...
            'TooltipString','Axes Indicator','Enable','off',...
            'BusyAction','cancel','Interruptible','off',...
            'CData',gFigAxes.TbarIcons{4},...
            'ClickedCallback',@TbarAxesInd);
        %% Create Toggle Edge Colorbar Button
        uitoggletool('Parent',hVisConTbar,'Tag','VisConTbarEdgeCbar','Separator','off',...
            'TooltipString','Edge Colorbar','Enable','off',...
            'BusyAction','cancel','Interruptible','off',...
            'CData',gFigAxes.TbarIcons{5},...
            'ClickedCallback',@TbarEdgeCbar);
        
        %% Create Toggle Information Box Button
        uitoggletool('Parent',hVisConTbar,'Tag','VisConTbarInformBox','Separator','off',...
            'TooltipString','Information Box','Enable','off',...
            'BusyAction','cancel','Interruptible','off',...
            'CData',gFigAxes.TbarIcons{6},...
            'ClickedCallback',@TbarInformBox);
        %% Create Edge Threshold Button
        uipushtool('Parent',hVisConTbar,'Tag','VisConTbarEdgeThres','Separator','on',...
            'TooltipString','Edge Threshold','Enable','off',...
            'BusyAction','cancel','Interruptible','off',...
            'CData',gFigAxes.TbarIcons{7},...
            'ClickedCallback','VisCon_EdgeThresDlg');
        %% Create Toggle Surface Visibility Button
        uitoggletool('Parent',hVisConTbar,'Tag','VisConTbarSurfVis','Separator','on',...
            'TooltipString','Surface Visibility','Enable','off',...
            'BusyAction','cancel','Interruptible','off',...
            'CData',gFigAxes.TbarIcons{3},...
            'ClickedCallback',@TbarToggSurf);
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
    %Axes indicator button function
    function TbarAxesInd(Src,Evnt)
        if strcmp(get(Src,'State'),'off')
            AxesIndicator off;
        elseif strcmp(get(Src,'State'),'on')
            AxesIndicator on;
        end
    end
    %Edge colorbar button function
    function TbarEdgeCbar(Src,Evnt)
        if strcmp(get(Src,'State'),'off')
            EdgeColorbar off;
        elseif strcmp(get(Src,'State'),'on')
            EdgeColorbar on;
        end
    end
    %Information box button function
    function TbarInformBox(Src,Evnt)
        if strcmp(get(Src,'State'),'off')
            InformationBox off;
        elseif strcmp(get(Src,'State'),'on')
            InformationBox on;
        end
    end
    %Brain surface button function
    function TbarToggSurf(Src,Evnt)
        if strcmp(get(Src,'State'),'off')
            BrainSurf off;
        elseif strcmp(get(Src,'State'),'on')
            BrainSurf on;
        end
    end
end