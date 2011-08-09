%VISCON_MENU Summary of this function goes here
%   Detailed explanation goes here
function VisCon_Menu()
global gVisConNet;
global gVisConFig;

hFig = findobj('Tag','VisConFig');
%% Create File Menu
hMenuFile = uimenu(hFig,'Label',' File ','Tag','VisConMenuFile',...
    'Enable','on');
uimenu(hMenuFile,'Label','New','Tag','VisConMenuNew',...
    'Enable','on',...
    'Accelerator', 'n',...
    'Callback','VisCon_NewFig();');
uimenu(hMenuFile,'Label','Open','Tag','VisConMenuOpen',...
    'Enable','on',...
    'Accelerator', 'o',...
    'Callback','VisCon_OpenDlg();');
uimenu(hMenuFile,'Label','Save','Tag','VisConMenuSave',...
    'Enable','off','Separator','on',...
    'Accelerator', 's',...
    'Callback',@MenuSaveFcn);
    function MenuSaveFcn(Src,Evnt)
        if gVisConFig.SaveState == 1
            if isempty(gVisConFig.FilePath)
                VisCon_SaveDlg();
            else
                SaveVisConFile(fullfile(gVisConFig.FilePath, gVisConFig.FileName));
            end
        end
    end
uimenu(hMenuFile,'Label','Save As ...','Tag','VisConMenuSaveAs',...
    'Enable','off',...
    'Callback','VisCon_SaveDlg();');
uimenu(hMenuFile,'Label','Export ...','Tag','VisConMenuExport',...
    'Enable','off',...
    'Callback','VisCon_ExportDlg();');
uimenu(hMenuFile,'Label','Exit','Tag','VisConMenuExit',...
    'Enable','on','Separator','on',...
    'Accelerator', 'q',...
    'Callback','close(gcf)');
%% Create Tools Menu
hMenuTools = uimenu(hFig,'Label',' Tools ','Tag','VisConMenuTools',...
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
uimenu(hMenuTools,'Label','Info. Box','Tag','VisConMenuInfoBox',...
    'Callback',@MenuInfoBox);
    function MenuInfoBox(Src,Evnt)
        if strcmp(get(Src,'Checked'),'off')
            InfoBox on;
        elseif strcmp(get(Src,'Checked'),'on')
            InfoBox off;
        end
    end
uimenu(hMenuTools,'Label','Subject Picker','Tag','VisConMenuSubjPicker',...
    'Callback',@MenuSubjPicker);
    function MenuSubjPicker(Src,Evnt)
        if strcmp(get(Src,'Checked'),'off')
            SubjPicker on;
        elseif strcmp(get(Src,'Checked'),'on')
            SubjPicker off;
        end
    end
hMenuTbars = uimenu(hMenuTools,'Label','Toolbars','Separator','on');
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
uimenu(hMenuTbars,'Label','Plot Edit',...
    'Checked','off',...
    'Callback',@MenuPlotEditTbar);
    function MenuPlotEditTbar(Src,Evnt)
        if strcmp(get(Src,'Checked'),'on')
            plotedit(hFig,'plotedittoolbar','hide');
            plotedit off;
            plottools off;
            set(Src,'Checked','off');
        elseif strcmp(get(Src,'Checked'),'off')
            plotedit(hFig,'plotedittoolbar','show');
            plotedit on; 
            set(Src,'Checked','on');
        end
    end
%% Create Network Menu
hMenuNetwork = uimenu(hFig,'Label',' Network ','Tag','VisConMenuNetwork',...
    'Enable','on');

uimenu(hMenuNetwork, 'Label', 'Import Networks ...', 'Tag', 'VisConMenuImportNets',...
    'Enable', 'on', 'Callback', 'VisCon_ImportNetDlg();');

uimenu(hMenuNetwork, 'Label', 'Add New Subject(s) Network ...', 'Tag', 'VisConMenuAddNewSubjNet',...
    'Enable', 'off');

hMenuNodeOper = uimenu(hMenuNetwork,'Label','Node Operation', 'Tag', 'VisConMenuNodeOper',...
    'Enable', 'off', 'Separator','on');
uimenu(hMenuNodeOper, 'Label', 'Select All Nodes',...
    'Callback',@MenuSelectAllNodes);
    function MenuSelectAllNodes(Src, Evnt)
        SelectNodes all;
    end
uimenu(hMenuNodeOper, 'Label', 'Hide Selected Nodes',...
    'Callback',@MenuHideSelectedNodes);
    function MenuHideSelectedNodes(Src, Evnt)
        if isempty(gVisConFig.NodeSelected)
            msgbox('Please first select node(s)!', 'VisualConnecome', 'warn');
        else
            HideNodes(gVisConFig.NodeSelected);
        end
    end
uimenu(hMenuNodeOper, 'Label', 'Show All Nodes',...
    'Callback','ShowNodes all');
uimenu(hMenuNodeOper, 'Label', 'Show/Hide Nodes ...');

hMenuEdgeOper = uimenu(hMenuNetwork,'Label','Edge Operation','Tag', 'VisConMenuEdgeOper',...
    'Enable', 'off');
uimenu(hMenuEdgeOper, 'Label', 'Connect Selected Nodes with All',...
    'Callback', @MenuConnectNodesAll);
    function MenuConnectNodesAll(Src,Evnt)
        if isempty(gVisConFig.NodeSelected)
            msgbox('Please first select node(s)!', 'VisualConnecome', 'warn');
        else
            ConnectNodesAll(gVisConFig.NodeSelected);
        end
    end
uimenu(hMenuEdgeOper, 'Label', 'Connect Selected Nodes with ...',...
    'Callback', @MenuConnectNodesWith);
    function MenuConnectNodesWith(Src,Evnt)
        if isempty(gVisConFig.NodeSelected)
            msgbox('Please first select node(s)!', 'VisualConnecome', 'warn');
        else
            StartNodes = gVisConFig.NodeSelected;
            for i = gVisConFig.NodeNum
                set(gVisConFig.hNodes,'ButtonDownFcn',...
                    {@VisCon_ConnectNodesWith,StartNodes});
            end
            VisCon_Hint('Select a node to connect/disconnect ...');
        end
    end

uimenu(hMenuEdgeOper, 'Label', 'Connect All Nodes',...
    'Callback', 'ConnectNodesAll all');
uimenu(hMenuEdgeOper, 'Label', 'Disconnect All Nodes',...
    'Callback', 'DisconnectNodesAll all');

uimenu(hMenuNetwork,'Label','Edge Threshold', 'Tag', 'VisConMenuEdgeThres',...
    'Separator','on', 'Enable', 'off',...
    'Callback','VisCon_EdgeThresDlg');

uimenu(hMenuNetwork,'Label','Connectivity Matrix Viewer','Tag', 'VisConMenuConMatViewer',...
    'Enable', 'off',...
    'Callback','ConMatViewer');
%% Create Surface Menu
hMenuSurface = uimenu(hFig,'Label',' Surface ','Tag','VisConMenuSurface',...
    'Enable','off');
uimenu(hMenuSurface,'Label','Import Brain Surface ...',...
    'Enable','on',...
    'Callback','VisCon_ImportSurfDlg()');
hMenuSurfVis = uimenu(hMenuSurface,'Label','Brain Surface Visibility',...
    'Separator','off');
uimenu(hMenuSurfVis,'Label','Both Hemisphere','Tag','VisConMenuBothSurfVis',...
    'Enable','off',...
    'Callback',@MenuBothSurfVis);
    function MenuBothSurfVis(Src,Evnt)
        if strcmp(get(Src,'Checked'),'on')
            BrainSurf off;
        elseif strcmp(get(Src,'Checked'),'off')
            BrainSurf on;
        end
    end
uimenu(hMenuSurfVis,'Label','Left Hemisphere','Tag','VisConMenuLSurfVis',...
    'Enable','off','Separator','on',...
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
hMenuAnalyze = uimenu(hFig,'Label',' Analyze ','Tag','VisConMenuAnalyze',...
    'Enable','off');
uimenu(hMenuAnalyze,'Label',' Calculate Network Property ','Tag','VisConNetProp',...
    'Callback','VisCon_CalcNetProp();');
%% Create Help Menu
hMenuHelp=uimenu(hFig,'Label',' Help ','Tag','VisConMenuHelp');
uimenu(hMenuHelp,'Label','User Guide',...
    'Callback',@MenuUserGuide);
    function MenuUserGuide(Src,Evnt)
        open(fullfile(gVisConFig.VisConPath,'Documents','User Guide.pdf'));
    end   
uimenu(hMenuHelp,'Label','About','Separator','off',...
    'Callback','VisCon_AboutDlg');
end

