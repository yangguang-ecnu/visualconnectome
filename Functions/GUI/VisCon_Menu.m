%VISCON_MENU Summary of this function goes here
%   Detailed explanation goes here
function VisCon_Menu()
hFig=findobj('Tag','VisConFig');
%% Create File Menu
hMenuFile=uimenu(hFig,'Label',' File ','Tag','VisConMenuFile',...
    'Enable','on');
uimenu(hMenuFile,'Label','Open','Tag','VisConMenuOpen',...
    'Enable','on','Accelerator','O',...
    'Callback','VisCon_OpenDlg');
uimenu(hMenuFile,'Label','Save As...   ','Tag','VisConMenuSave',...
    'Enable','off','Accelerator','S',...
    'Callback','VisCon_SaveDlg');
uimenu(hMenuFile,'Label','Exit','Tag','VisConMenuExit',...
    'Enable','on','Separator','on','Accelerator','Q',...
    'Callback','close(gcf)');
%% Create Tools Menu
hMenuTools=uimenu(hFig,'Label',' Tools ','Tag','VisConMenuTools',...
    'Enable','off');
uimenu(hMenuTools,'Label','Axes Indicator','Tag','VisConMenuAxesInd',...
    'Callback',@MenuAxesInd);
    function MenuAxesInd(Src,Evnt)
        if strcmp(get(Src,'Checked'),'off')
            AxesIndicator on;
        elseif strcmp(get(Src,'Checked'),'on')
            AxesIndicator off;
        end
    end
uimenu(hMenuTools,'Label','Edge Colorbar','Tag','VisConMenuEdgeCbar',...
    'Callback',@MenuEdgeCbar);
    function MenuEdgeCbar(Src,Evnt)
        if strcmp(get(Src,'Checked'),'off')
            EdgeColorbar on;
        elseif strcmp(get(Src,'Checked'),'on')
            EdgeColorbar off;
        end
    end
uimenu(hMenuTools,'Label','Information Box','Tag','VisConMenuInformBox',...
    'Callback',@MenuInformBox);
    function MenuInformBox(Src,Evnt)
        if strcmp(get(Src,'Checked'),'off')
            InformationBox on;
        elseif strcmp(get(Src,'Checked'),'on')
            InformationBox off;
        end
    end
hMenuTbars=uimenu(hMenuTools,'Label','Toolbars','Separator','on');
uimenu(hMenuTbars,'Label','VisualConnectome',...
    'Checked','on',...
    'Callback',@MenuVisConTbar);
    function MenuVisConTbar(Src,Evnt)
        if strcmp(get(Src,'Checked'),'on')
            VisCon_Toolbar hide;
            set(Src,'Checked','off');
        elseif strcmp(get(Src,'Checked'),'off')
            VisCon_Toolbar show;
            set(Src,'Checked','on');
        end
    end
uimenu(hMenuTbars,'Label','Camera',...
    'Checked','off',...
    'Callback',@MenuCameraTbar);
    function MenuCameraTbar(Src,Evnt)
        if strcmp(get(Src,'Checked'),'on')
            cameratoolbar(hFig,'hide');
            set(Src,'Checked','off');
            hAxes=findobj(hFig,'Tag','VisConAxes');
            hAxesInd=findobj(hFig,'Tag','VisConAxesInd');
            [az,el]=view(hAxes);
            view(hAxesInd,az,el);
        elseif strcmp(get(Src,'Checked'),'off')
            cameratoolbar(hFig,'show');
            set(Src,'Checked','on');
        end
    end
uimenu(hMenuTbars,'Label','Plot Edit',...
    'Checked','off',...
    'Callback',@MenuPlotEditTbar);
    function MenuPlotEditTbar(Src,Evnt)
        if strcmp(get(Src,'Checked'),'on')
            plotedit(hFig,'plotedittoolbar','hide');
            set(Src,'Checked','off');
        elseif strcmp(get(Src,'Checked'),'off')
            plotedit(hFig,'plotedittoolbar','show');
            set(Src,'Checked','on');
        end
    end
uimenu(hMenuTools,'Label','Edit Plot',...
    'Separator','on');
%% Create Network Menu
hMenuNetwork=uimenu(hFig,'Label',' Network ','Tag','VisConMenuNetwork',...
    'Enable','off');
uimenu(hMenuNetwork,'Label','Connect Node with All...','Tag','VisConMenuConnNodesAll',...
    'Accelerator','A',...
    'Callback',@MenuConnNodeAllFcn);
    function MenuConnNodeAllFcn(Src,Evnt)
        if strcmp(get(Src,'Checked'),'off')
            VisCon_ConnNodeAllMode on;
        elseif strcmp(get(Src,'Checked'),'on')
            VisCon_ConnNodeAllMode off;
        end
    end
uimenu(hMenuNetwork,'Label','Connect Nodes with...','Tag','VisConMenuConnNodesWith',...
    'Accelerator','B',...
    'Callback',@MenuConnNodesWithFcn);
    function MenuConnNodesWithFcn(Src,Evnt)
        if strcmp(get(Src,'Checked'),'off')
            VisCon_ConnNodesWithMode on;
        elseif strcmp(get(Src,'Checked'),'on')
            VisCon_ConnNodesWithMode off;
        end
    end
uimenu(hMenuNetwork,'Label','Edge Threshold',...
    'Accelerator','T','Separator','on',...
    'Callback','VisCon_EdgeThresDlg');
%% Create Surface Menu
hMenuSurface=uimenu(hFig,'Label',' Surface ','Tag','VisConMenuSurface',...
    'Enable','off');
uimenu(hMenuSurface,'Label','Import Brain Surface...',...
    'Enable','on');
hMenuSurfVis=uimenu(hMenuSurface,'Label','Brain Surface Visibility',...
    'Separator','on');
uimenu(hMenuSurfVis,'Label','Left Hemisphere','Tag','VisConMenuLSurfVis',...
    'Enable','off',...
    'Callback',@MenuLSurfVis);
    function MenuLSurfVis(Src,Evnt)
        if strcmp(get(Src,'Checked'),'on')
            BrainSurf off left;
        elseif strcmp(get(Src,'Checked'),'off')
            BrainSurf on left;
        end
    end
uimenu(hMenuSurfVis,'Label','Right Hemisphere','Tag','VisConMenuRSurfVis',...
    'Enable','off',...
    'Callback',@MenuRSurfVis);
    function MenuRSurfVis(Src,Evnt)
        if strcmp(get(Src,'Checked'),'on')
            BrainSurf off right;
        elseif strcmp(get(Src,'Checked'),'off')
            BrainSurf on right;
        end
    end
%% Create Analyze Menu
hMenuAnalyze=uimenu(hFig,'Label',' Analyze ','Tag','VisConMenuAnalyze',...
    'Enable','off');
%% Create Help Menu
hMenuHelp=uimenu(hFig,'Label',' Help ','Tag','VisConMenuHelp');
uimenu(hMenuHelp,'Label','User Guide',...
    'Callback',@MenuUserGuide);
    function MenuUserGuide(Src,Evnt)
        global gFigAxes;
        open(fullfile(gFigAxes.VisConPath,'Documents','User Guide.pdf'));
    end   
uimenu(hMenuHelp,'Label','About','Separator','on',...
    'Callback','VisCon_AboutDlg');
end

