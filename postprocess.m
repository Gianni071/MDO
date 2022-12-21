clc
clear all
close all

matobj = matfile("Run1.mat");

xnor = matobj.x;

CSTroot = readmatrix('RootRefCST.txt');
CSTtip = readmatrix('TipRefCST.txt');
CST = [CSTroot; CSTtip];

xref = [CST; 3.94; 0.75; 0.475; 100; 100; 17.82; 26.21;  4882.55 ; 10023; 16];
data.xref = [CST; 3.94; 0.75; 0.475; 100; 100; 17.82; 26.21;  4882.55 ; 10023; 16];
x = xnor.*xref;


