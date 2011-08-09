clc;
clear;
load Network.mat
%SurfStat exsits?
path=which('SurfStatReadSurf');
if isempty(path)
    VisConPath=which('VisualConnectome.m');
    addpath(fullfile(gFigAxes.VisConPath,'Plugins','SurfStat'));
end
%Load surface data
LSurf=SurfStatReadSurf('ICBM152_midsurf_left.obj');
RSurf=SurfStatReadSurf('ICBM152_midsurf_right.obj');
%Change field names of surface structure
LSurfData.Faces=LSurf.tri;
LSurfData.Vertices=LSurf.coord.';
RSurfData.Faces=RSurf.tri;
RSurfData.Vertices=RSurf.coord.';
clear LSurf RSurf;
%Run VisualConnectome
VisualConnectome(AdjMat,PosMat,'LSurfData',LSurfData,'RSurfData',RSurfData);