% %%__Plot the Wing in 3D__%%

clc
close all
clear all

%% Define Constants
global data

%Fuselage drag
data.Dfus = 12307.5387; %[N]

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
data.WAW = 26855.57; %[kg] ZFW - Wing weight 
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

matobj = matfile("run5.mat");

xnor = matobj.x;

CSTroot = readmatrix('RootRefCST.txt');
CSTtip = readmatrix('TipRefCST.txt');
CST = [CSTroot; CSTtip];

xref = [CST; 3.94; 0.75; 0.475; 100; 100; 17.82; 26.21;  4882.55 ; 10023; 16];
data.xref = [CST; 3.94; 0.75; 0.475; 100; 100; 17.82; 26.21;  4882.55 ; 10023; 16];
x = xnor.*xref; 

CST_root    = [ x(1:12) ];
CST_tip     = [ x(13:24) ];

RootUp = transpose(CST_root(1:6));
RootLow = transpose(CST_root(7:12));
TipUp = CST_tip(1:6);
TipLow = CST_tip(7:12);

xairfoil = transpose(linspace(0,1,30));

[Xtu_root, Xtl_root] = D_airfoil2(RootUp, RootLow, xairfoil);
[Xtu_tip, Xtl_tip] = D_airfoil2(TipUp, TipLow, xairfoil);

Xtu_root1(:,1) = Xtu_root(:,1)*x(25); %%chordwise
Xtu_root1(:,2) = Xtu_root(:,2)*x(25); %%up and down
Xtl_root1(:,1) = Xtl_root(:,1)*x(25); %%chordwise
Xtl_root1(:,2) = Xtl_root(:,2)*x(25); %%up and down

dihedral = data.dihedral; %[deg]
x2 = x(25) - x(25)*x(26) + data.y2*sind(data.TEsw); 
y2 = data.y2; %[m]
z2 = y2*sind(dihedral);

Xtu_kink(:,1) = Xtu_root(:,1)*x(25)*x(26) + x2; %%chordwise
Xtu_kink(:,2) = Xtu_root(:,2)*x(25)*x(26) + z2; %%up and down
Xtl_kink(:,1) = Xtl_root(:,1)*x(25)*x(26) + x2; %%chordwise
Xtl_kink(:,2) = Xtl_root(:,2)*x(25)*x(26) + z2; %%up and down

x3 = x2 + (x(31)/2 - data.y2)*sind(x(30));
y3 = x(31)/2;
z3 = y3*sind(-5);
z3 = y3*sind(dihedral);

Xtu_tip(:,1) = Xtu_tip(:,1)*x(25)*x(26)*x(27) + x3; %%chordwise
Xtu_tip(:,2) = Xtu_tip(:,2)*x(25)*x(26)*x(27) + z3; %%up and down
Xtl_tip(:,1) = Xtl_tip(:,1)*x(25)*x(26)*x(27) + x3; %%chordwise
Xtl_tip(:,2) = Xtl_tip(:,2)*x(25)*x(26)*x(27) + z3; %%up and down

X = [[Xtu_root1(:,1); flip(Xtl_root1(:,1))], [Xtu_kink(:,1); flip(Xtl_kink(:,1))], [Xtu_tip(:,1); flip(Xtl_tip(:,1))]];
Y = [zeros(60,1), data.y2*ones(60,1), x(31)/2*ones(60,1)];
Z = [[Xtu_root1(:,2); flip(Xtl_root1(:,2))] , [Xtu_kink(:,2); flip(Xtl_kink(:,2))], [Xtu_tip(:,2); flip(Xtl_tip(:,2))]];

surf(X, Y, Z)
title('Isometric View of Optimized Wing')
xlabel('x [m]')
ylabel('y [m]')
zlabel('z [m]')
axis equal
f = gcf;
exportgraphics(f, '7_IsometricWing.png', 'Resolution', 300);