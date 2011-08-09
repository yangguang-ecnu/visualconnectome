%MATRIXVIEWER Summary of this function goes here
%   Detailed explanation goes here
function MatrixViewer()
global gNetwork;
hMatView=findobj('Tag','VisConMatView');
if isempty(hMatView)
    hMatView=figure('Name','Matrix Viewer - VisualConnectome','NumberTitle','off',...
        'Tag','VisConMatView');
else
    figure(hMatView);
end
Matrix=gNetwork.AdjMat;
Matrix(Matrix<gNetwork.EdgeRange(1))=0;
Matrix(Matrix>gNetwork.EdgeRange(2))=0;
surface(Matrix);
axis image;
set(gca,'XAxisLocation','top','YDir','reverse','TickDir','out');
colormap default;
hCbar=colorbar;
caxis([0 1]);
title('Connectivity Matrix Viewer');
title(hCbar,'Weight');
end

