clc
close all
clear all

%% Define Constants
global data

%Fuselage drag
data.Dfus = 5100.3; %[N]

%Reference planform values
data.x1 = 0 %[m]
data.y1 = 0 %[m]
data.z1 = 0 %[m]
data.y2 = 5.25; %[m]
data.TEsw = 6.15; %[deg]
data.dihedral = -5; %[deg]
data.Sref = 77.3; %[m^2]
data.front_spar = 0.2 %[-]
data.rear_spar = 0.6 %[-]

%Change this!
data.WAW = 9.81*10000; %[N] GUESS VALUE

%Flight Conditions and Atmospheric Conditions (Atmospheric conditions: https://www.digitaldutch.com/atmoscalc/)
data.Vcr = 356; %[kts]
data.hcr = 29000; %[ft]
data.rho = 0.475448; %[kg/m^3]
data.a = 304.484; %[m/s]
data.dynvis = 0.0000151075; %[Pa s]

%Flight Conditions and Atmospheric Conditions (Atmospheric conditions: https://www.digitaldutch.com/atmoscalc/)


%% Initial Design Vector
%Design Vector Entries:
%x = [CST,c1,lambda1,lambda2,theta2,theta3,LEsw,b,Wwing,Wfuel,L/DcrAC]
%x = [1-24,25, 26      27      28     29    30  31  32    33     34]

%Get CST coefficients
CSTroot = readmatrix('RootRefCST.txt');
CSTtip = readmatrix('TipRefCST.txt');

CST = [CSTroot;CSTtip];



%% Bounds Vectors