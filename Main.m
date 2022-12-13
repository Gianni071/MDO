clc
close all
clear all

%% Define Constants
global data

%Fuselage drag
data.Dfus = 5100.3; %[N]

%Reference planform values
data.y2 = 5.25; %[m]
data.TEsw = 6.15; %[deg]
data.dihedral = -5; %[deg]
data.Sref = 77.3; %[m^2]

%Change this!
data.WAW = 9.81*10000; %[N] GUESS VALUE

%Flight Conditions and Atmospheric Conditions (Atmospheric conditions: https://www.digitaldutch.com/atmoscalc/)
data.Vcr = 356; %[kts]
data.hcr = 29000; %[ft]
data.rho = 0.475448; %[kg/m^3]
data.a = 304.484; %[m/s]
data.dynvis = 0.0000151075; %[Pa s]

%% Write EMWET init file




%% Initial Design Vector
%Design Vector Entries:
%x = [CST,c1,lambda1,lambda2,theta2,theta3,LEsw,b,Wwing,Wfuel,L/DcrAC]
%x = [1-24,25, 26      27      28     29    30  31  32    33     34]

%Get initial CST coefficients
CSTroot = readmatrix('RootRefCST.txt');
CSTtip = readmatrix('TipRefCST.txt');
CST = [CSTroot;CSTtip];

x0 = [CST;3.94;0.75;0.475;0;0;17.82;26.21;5000;10023;16];

%% Bounds Vectors
CSTlb = readmatrix('CSTLowerBound.txt');
CSTub = readmatrix('CSTUpperBound.txt');

%Lower Bound 
%CHANGE Wwing!!!!!
lb = [CSTlb;3.152;0.6;0.38;-15;-15;10;20.96;4000;8018;11.2];

%Upper Bound
ub = [CSTub;4.728;0.9;0.57;15;15;25;31.44;6000;12027;20.8];
