clc
clear all
close all

global data

matobj = matfile("Run1.mat");

xnor = matobj.x;

CSTroot = readmatrix('RootRefCST.txt');
CSTtip = readmatrix('TipRefCST.txt');
CST = [CSTroot; CSTtip];

xref = [CST; 3.94; 0.75; 0.475; 100; 100; 17.82; 26.21;  4882.55 ; 10023; 16];
data.xref = [CST; 3.94; 0.75; 0.475; 100; 100; 17.82; 26.21;  4882.55 ; 10023; 16];
x = xnor.*xref;

%Compute relevant values using x vector

%% Initial Design Vector
%Design Vector Entries:
%x = [CST,c1,lambda1,lambda2,theta2,theta3,LEsw,b,Wwing,Wfuel,L/DcrAC]
%x = [1-24,25, 26      27      28     29    30  31  32    33     34]

%%__Plot the Wing__%%
x2 = x(25) + data.y2 * sind(data.TESW) - x(25)*x(26);
x3 = x2 + (x(31)/2 - data.y2)*sind(x(30));

plot([data.x1, x2, x3, data.x1 + x(25), x2 + x(25)*x(26), x3 + x(25)*x(26)*x(27)], [data.y1, data.y2, x(31)/2, data.y1, data.y2, x(31)/2])
