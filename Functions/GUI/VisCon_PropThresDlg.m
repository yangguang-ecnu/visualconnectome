%VISCON_PROPTHRESUI Summary of this function goes here
%   Detailed explanation goes here
function VisCon_PropThresDlg()
global gNetwork;

hFig=findobj('Tag','VisConFig');
FigPos=get(hFig,'Position');
DlgPos=[FigPos([1 2])+FigPos([3 4])/2-[200 0],400,100];

MinThres=sum(gNetwork.SortedAdj>=gNetwork.EdgeRange(1))/gNetwork.EdgeNum*100;
MaxThres=sum(gNetwork.SortedAdj<=gNetwork.EdgeRange(2))/gNetwork.EdgeNum*100;
if MinThres<1,    MinThres=1;   end;
if MaxThres<1,    MaxThres=1;   end;

PropThresDlg=dialog('Name','Proportional Threshold',...
    'Units','Pixel','Position',DlgPos);
ButtonGroup=uibuttongroup(PropThresDlg,'Units','normalized','Position',[0 0 1 1],...
    'SelectionChangeFcn',@ButtonGroupFcn);
MinThresSlider=uicontrol(ButtonGroup,'Style','slider',...
    'Units','Pixel','Position',[45 55 250 16],...
    'Min',1,'Max',100,...
    'Value',MinThres,...
    'Callback',@MinThresSliderFcn);
MaxThresSlider=uicontrol(ButtonGroup,'Style','slider',...
    'Units','Pixel','Position',[45 15 250 16],...
    'Min',1,'Max',100,...
    'Value',MaxThres,...
    'Callback',@MaxThresSliderFcn);

MinThresEdit=uicontrol(ButtonGroup,'Style','edit',...
    'Units','Pixel','Position',[340 54 31 20],...
    'String',sprintf('%.3f',MinThres),...
    'Callback',@MinThresEditFcn);
MaxThresEdit=uicontrol(ButtonGroup,'Style','edit',...
    'Units','Pixel','Position',[340 14 31 20],...
    'String',sprintf('%.3f',MaxThres),...
    'Callback',@MaxThresEditFcn);

MinThresRadio=uicontrol(ButtonGroup,'Style','radiobutton',...
    'Units','Pixel','Position',[5 75 200 14],...
    'String','Proportional Threshold (Strongest)',...
    'TooltipString','This percentage of strongest edge will be retained');
MaxThresRadio=uicontrol(ButtonGroup,'Style','radiobutton',...
    'Units','Pixel','Position',[5 35 200 14],...
    'String','Proportional Threshold (Weakest)',...
    'TooltipString','This percentage of weakest edge will be retained');

uicontrol(ButtonGroup,'Style','text',...
    'Units','Pixel','Position',[10 55 30 16],...
    'String','1%');
uicontrol(ButtonGroup,'Style','text',...
    'Units','Pixel','Position',[10 15 30 16],...
    'String','1%');
uicontrol(ButtonGroup,'Style','text',...
    'Units','Pixel','Position',[300 55 30 16],...
    'String','100%');
uicontrol(ButtonGroup,'Style','text',...
    'Units','Pixel','Position',[300 15 30 16],...
    'String','100%');
uicontrol(ButtonGroup,'Style','text',...
    'Units','Pixel','Position',[375 55 10 16],...
    'String','%');
uicontrol(ButtonGroup,'Style','text',...
    'Units','Pixel','Position',[375 15 10 16],...
    'String','%');

set(MaxThresSlider,'Enable','off');
set(MaxThresEdit,'Enable','off');

    function MinThresSliderFcn(Src,Evnt)
        MinThres=get(Src,'Value');
        set(MinThresEdit,'String',sprintf('%.3f',MinThres));
        set(0,'CurrentFigure',hFig);
        ThresholdEdges('proportional',MinThres/100);
    end

    function MaxThresSliderFcn(Src,Evnt)
        MaxThres=get(Src,'Value');
        set(MaxThresEdit,'String',sprintf('%.3f',MaxThres));
        set(0,'CurrentFigure',hFig);
        ThresholdEdges('proportional',[],MaxThres/100);
    end

    function MinThresEditFcn(Src,Evnt)
        MinThres=str2double(get(Src,'String'));
        errmsg=sprintf('You must enter a number between 1 and 100');
        if ~isnan(MinThres)
            if MinThres<1 || MinThres>100
                errordlg(errmsg,'Threshold error');
            end
        else
            errordlg(errmsg,'Threshold error');
        end
        set(MinThresSlider,'Value',MinThres);
        set(0,'CurrentFigure',hFig);
        ThresholdEdges('proportional',MinThres/100);
    end

    function MaxThresEditFcn(Src,Evnt)
        MaxThres=str2double(get(Src,'String'));
        errmsg=sprintf('You must enter a number between 1 and 100');
        if ~isnan(MaxThres)
            if MaxThres<1 || MaxThres>100
                errordlg(errmsg,'Threshold error');
            end
        else
            errordlg(errmsg,'Threshold error');
        end
        set(MaxThresSlider,'Value',MaxThres);
        set(0,'CurrentFigure',hFig);
        ThresholdEdges('proportional',[],MaxThres/100);
    end

    function ButtonGroupFcn(Src,Evnt)
        if Evnt.NewValue==MinThresRadio
            set(MinThresSlider,'Enable','on');
            set(MinThresEdit,'Enable','on');
            set(MaxThresSlider,'Enable','off');
            set(MaxThresEdit,'Enable','off');
        elseif Evnt.NewValue==MaxThresRadio
            set(MinThresSlider,'Enable','off');
            set(MinThresEdit,'Enable','off');
            set(MaxThresSlider,'Enable','on');
            set(MaxThresEdit,'Enable','on');
        end
    end

end

