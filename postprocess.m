clc
close all
clear all

%% Define Constants
global data

%Fuselage drag
data.Dfus = 10899.25; %[N]

%Reference planform values
data.x1 = 0; %[m]
data.y1 = 0; %[m]
data.z1 = 0; %[m]
data.y2 = 5.25; %[m]
data.z2 = -0.458; %[m]
data.TEsw = 6.15; %[deg]
data.dihedral = -5; %[deg]
data.Sref = 75.246; %[m^2]
data.Vaux = 1.174; %[m^3]

%Change this!
data.WAW = 27301.35; %[kg] ZFW - Wing weight 
data.WSref = 560.61; %[kg/m^2]
data.MTOWref = 42184; %[kg]

%Flight Conditions and Atmospheric Conditions (Atmospheric conditions: https://www.digitaldutch.com/atmoscalc/)
data.Vcr = 356; %[kts]
data.hcr = 29000; %[ft]
data.rho = 0.475448; %[kg/m^3]
data.a = 304.484; %[m/s]
data.dynvis = 0.0000151075; %[Pa s]

%Properties of Aluminium 
data.E_al        =    70E9;         %N/m2
data.rho_al      =    2800;         %kg/m3
data.Ft_al       =    295E6;        %N/m2
data.Fc_al       =    295E6;        %N/m2

%EMWET Input Constants 
data.section_num =    3;       %[number of sections]
data.airfoil_num =    2;       %[number of airfoils]
data.eng_mass    =    606;     %[kg]
data.pitch_rib   =    0.5;     %[m]
data.eff_factor  =    0.96;    %Depend on the stringer type
data.front_spar  =    0.16;      %[-]
data.rear_spar   =    0.6;      %[-]
data.ftank_start =    0.1;     %[y/y3]
data.ftank_end   =    0.85;    %[y/y3]
data.eng_num     =    2;       %[-]
data.eng_ypos1   =    0.315;   %[y/y3]
data.eng_ypos2   =    0.50;    %[y/y3]

matobj = matfile("run3.mat");

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
x2 = x(25) + data.y2 * sind(data.TEsw) - x(25)*x(26);
x3 = x2 + (x(31)/2 - data.y2)*sind(x(30));
x2ref = xref(25) + data.y2 * sind(data.TEsw) - xref(25)*xref(26);
x3ref = x2ref + (xref(31)/2 - data.y2)*sind(xref(30));

plot([data.x1, x2, x3,  x3 + x(25)*x(26)*x(27), x2 + x(25)*x(26), data.x1 + x(25)], [data.y1, data.y2, x(31)/2, x(31)/2, data.y2, data.y1], "b")
hold on 
plot([data.x1, x2ref, x3ref,  x3ref + xref(25)*xref(26)*xref(27), x2ref + xref(25)*xref(26), data.x1 + xref(25)], [data.y1, data.y2, xref(31)/2, xref(31)/2, data.y2, data.y1], "r")
xlim([0,16])
ylim([0,16])
figure()

%%_Plot the Airfoil__%%
CST_root    = [ x(1:12) ];
CST_tip     = [ x(13:24) ];
CST_root_init    = [ xref(1:12) ];
CST_tip_init    = [ xref(13:24) ];

RootUp = transpose(CST_root(1:6));
RootLow = transpose(CST_root(7:12));
RootUp_init = transpose(CST_root_init(1:6));
RootLow_init = transpose(CST_root_init(7:12));
TipUp = CST_tip(1:6);
TipLow = CST_tip(7:12);
TipUp_init = CST_tip_init(1:6);
TipLow_init = CST_tip_init(7:12);

xairfoil = transpose(linspace(0,1,101));

[Xtu_root, Xtl_root] = D_airfoil2(RootUp, RootLow, xairfoil);
[Xtu_tip, Xtl_tip] = D_airfoil2(TipUp, TipLow, xairfoil);
[Xtu_root_init, Xtl_root_init] = D_airfoil2(RootUp_init, RootLow_init, xairfoil);
[Xtu_tip_init, Xtl_tip_init] = D_airfoil2(TipUp_init, TipLow_init, xairfoil);

plot(Xtl_root(:,1), Xtl_root(:,2), "b")
hold on 
plot(Xtu_root(:,1), Xtu_root(:,2), "b")
hold on
plot(Xtl_root_init(:,1), Xtl_root_init(:,2), "r")
hold on 
plot(Xtu_root_init(:,1), Xtu_root_init(:,2), "r")
ylim([-0.5, 0.5])
figure()

plot(Xtl_tip(:,1), Xtl_tip(:,2), "b")
hold on 
plot(Xtu_tip(:,1), Xtu_tip(:,2), "b")
hold on
plot(Xtl_tip_init(:,1), Xtl_tip_init(:,2), "r")
hold on 
plot(Xtu_tip_init(:,1), Xtu_tip_init(:,2), "r")
ylim([-0.5, 0.5])
figure()

% %%__Plot the Wing in 3D__%%
% scatter3(Xtl_tip(:,1), Xtl_tip(:,2), xref(31)*ones(1, 101)')
% hold on
% scatter3(Xtu_tip(:,1), Xtu_tip(:,2), xref(31)*ones(1, 101)')
% hold on 
% scatter3(Xtl_root(:,1), Xtl_root(:,2), 0.*ones(1, 101)')
% hold on
% scatter3(Xtu_root(:,1), Xtu_root(:,2), 0.*ones(1, 101)')


