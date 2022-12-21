clc
clear all
close all

global data
%% This function is made to test aerodynamics function and calculate Fuselage Drag
%Design Vector Entries:
%x = [CST,c1,lambda1,lambda2,theta2,theta3,LEsw,b,Wwing,Wfuel,L/DcrAC]
%x = [1-24,25, 26      27      28     29    30  31  32    33     34]

data.x1 = 0; %[m]
data.y1 = 0; %[m]
data.z1 = 0; %[m]
data.y2 = 5.25; %[m]
data.z2 = -0.458; %[m]
data.TEsw = 6.15; %[deg]
data.dihedral = -5; %[deg]
data.Sref = 77.3; %[m^2]
data.Vaux = 1.174; %[m^3]
data.WAW = 30951.45; %[kg] ZFW - Wing weight 
data.WSref = 545.72; %[kg/m^2]

%Flight Conditions and Atmospheric Conditions (Atmospheric conditions: https://www.digitaldutch.com/atmoscalc/)
data.Vcr = 356; %[kts]
data.hcr = 29000; %[ft]
data.rho = 0.475448; %[kg/m^3]
data.a = 304.484; %[m/s]
data.dynvis = 0.0000151075; %[Pa s]
%Reference design vector
CSTroot = readmatrix('RootRefCST.txt');
CSTtip = readmatrix('TipRefCST.txt');

CST = [CSTroot;CSTtip];

vis = 1;
x = [CST; 3.94; 0.75; 0.475; 100; 100; 17.82; 26.21;  4882.55 ; 10023; 16];
c1 = x(25);
lambda1 = x(26);
lambda2 = x(27);
b = x(31);
Wwinghat = x(32);
Wfuelhat = x(33);
LDhat = x(34);

y2 = 5.25;
y3 = b/2;
c2 = lambda1*c1;
c3 = lambda2*c2;

S = 2*(y2*(c1+c2)/2+(y3-y2)*(c2+c3)/2);

[CL,CD] = aerodynamics(x,vis);

%Reference L/D
LDref = x(34);

%Fuselage CD
CDfus = CL/LDref - CD;

%Fuselage Drag Force
Vcr = 356; %[kts]
rho = 0.475448; %[kg/m^3]
V = 0.51444*Vcr; %[m/s]
Sref = 77.3; %[m^2]
format long
Dfus = CDfus*0.5*rho*V^2*S;



