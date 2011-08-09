clc;
clear;
load Network.mat

LSurf=SurfStatReadSurf('ICBM152_midsurf_left.obj');
RSurf=SurfStatReadSurf('ICBM152_midsurf_right.obj');

LSurfData.Faces=LSurf.tri;
LSurfData.Vertices=LSurf.coord.';
RSurfData.Faces=RSurf.tri;
RSurfData.Vertices=RSurf.coord.';

VisualConnectome(AdjMat,PosMat,'LSurfData',LSurfData,'RSurfData',RSurfData);