clc
clear all
close all

%% This function is made to test aerodynamics function
%Design Vector Entries:
%x = [CST,c1,lambda1,lambda2,theta2,theta3,LEsw,b,Wwing,Wfuel,L/DcrAC]
%x = [1-24,25, 26      27      28     29    30  31  32    33     34]


%Reference design vector
CSTroot = readmatrix('RootRefCST.txt');
CSTtip = readmatrix('TipRefCST.txt');

CST = [CSTroot;CSTtip];

vis = 1;
x = [CST;3.94;0.75;0.475;0;0;17.82;26.21;5000;10023;16];

[CL,CD] = aerodynamics(x,vis);

