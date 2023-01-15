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

%%Obtain the final optimized design variable matrix 
matobj = matfile("run5.mat");
xnor = matobj.x;

CSTroot = readmatrix('RootRefCST.txt');
CSTtip = readmatrix('TipRefCST.txt');
CST = [CSTroot; CSTtip];

xref = [CST; 4.128; 0.75; 0.522; 100; 100; 17.82; 26.34;  4774.7 ; 10553.734; 15];
data.xref = xref;
x = xnor.*xref;

%Design Vector Entries:
%x = [CST,c1,lambda1,lambda2,theta2,theta3,LEsw,b,Wwing,Wfuel,L/DcrAC]
%x = [1-24,25, 26      27      28     29    30  31  32    33     34]

%%__Plot the Planform%%
x2 = x(25) + data.y2 * sind(data.TEsw) - x(25)*x(26);
x3 = x2 + (x(31)/2 - data.y2)*sind(x(30));
x2ref = xref(25) + data.y2 * sind(data.TEsw) - xref(25)*xref(26);
x3ref = x2ref + (xref(31)/2 - data.y2)*sind(xref(30));

plot([data.y1, data.y2, x(31)/2, x(31)/2, data.y2, data.y1], [data.x1, x2, x3,  x3 + x(25)*x(26)*x(27), x2 + x(25)*x(26), data.x1 + x(25)]*-1, "b")
hold on 
plot([data.y1, data.y2, xref(31)/2, xref(31)/2, data.y2, data.y1], [data.x1, x2ref, x3ref,  x3ref + xref(25)*xref(26)*xref(27), x2ref + xref(25)*xref(26), data.x1 + xref(25)]*-1, "r")
xlim([0,14])
ylim([-10,4])
title('Final and Initial Wing Planform')
xlabel('y [m]')
ylabel('x [m]')
legend('Final', 'Initial')
f = gcf;
exportgraphics(f, '1_Planform.png', 'Resolution', 300);
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
plot(Xtl_root_init(:,1), Xtl_root_init(:,2), "r")
hold on 
plot(Xtu_root(:,1), Xtu_root(:,2), "b")
hold on
plot(Xtu_root_init(:,1), Xtu_root_init(:,2), "r")
ylim([-0.5, 0.5])
title('Final and Initial Root Airfoils with Normalized Chord length')
xlabel('Normalized Chord [-]')
ylabel('z [-]')
legend('Final', 'Initial')
f = gcf;
exportgraphics(f, '2_RootAirfoils.png', 'Resolution', 300);
figure()

plot(Xtl_tip(:,1), Xtl_tip(:,2), "b")
hold on 
plot(Xtl_tip_init(:,1), Xtl_tip_init(:,2), "r")
hold on 
plot(Xtu_tip(:,1), Xtu_tip(:,2), "b")
hold on
plot(Xtu_tip_init(:,1), Xtu_tip_init(:,2), "r")
ylim([-0.5, 0.5])
title('Final and Initial Tip Airfoils with Normalized Chord length')
xlabel('Normalized Chord [-]')
ylabel('z [-]')
legend('Final', 'Initial')
f = gcf;
exportgraphics(f, '3_TipAirfoils.png', 'Resolution', 300);
figure()

%% Spanwise lift distributions cruise conditions 
y2 = data.y2; %[m]
TEsw = data.TEsw; %[deg]
dihedral = data.dihedral; %[deg]
WAW = 9.81*data.WAW; %[N] Guess value for now
V = data.Vcr*0.51444; %[m/s]
rho = data.rho; %[kg/m^3]
alt = data.hcr*0.3048; %[m]
a = data.a; %[m/s]
dynvis = data.dynvis; %[Pa s]

%Design Variables
CST1 = x(1:12); %[-]
CST2 = x(13:24); %[-]
CST1 = transpose(CST1);
CST2 = transpose(CST2);
CST = [CST1;CST2];
c1 = x(25); %[m]
lambda1 = x(26); %[-]
lambda2 = x(27); %[-]
theta2 = x(28)-100; %[deg]
theta3 = x(29)-100; %[deg]
LEsw = x(30); %[deg]
b = x(31); %[m]
Wwing = 9.81*x(32); %[N]
Wfuel = 9.81*x(33); %[N]

%Computed Variables
c2 = lambda1*c1;
c3 = lambda2*c2;
x2 = c1 + y2*sind(TEsw) - c2;
y3 = b/2;
x3 = x2 + (y3-y2)*sind(LEsw);
z2 = y2*sind(dihedral);
z3 = y3*sind(dihedral);

%Surface Area Wing
S = 2*(y2*(c1+c2)/2+(y3-y2)*(c2+c3)/2);

%Design Weight
WTO = Wwing+WAW+Wfuel;
Wdes = sqrt(WTO*(WTO-Wfuel));

%Flight Conditions 
Re = ((S/b)*rho*V)/dynvis;
M = V/a;
CL = Wdes/(0.5*rho*V^2*S);

%% Aerodynamic solver for Spanwise Lift Distribution in Cruise Conditions
% Wing planform geometry 
%                x    y     z   chord(m)    twist angle (deg) 
AC.Wing.Geom = [0     0     0     c1         0;
                x2    y2   z2     c2       theta2;
                x3    y3   z3     c3       theta3];

% Wing incidence angle (degree)
AC.Wing.inc  = 0;   
            
% Airfoil coefficients input matrix
%                    | ->     upper curve coeff.                <-|   | ->       lower curve coeff.       <-| 
%AC.Wing.Airfoils   = [0.2171    0.3450    0.2975    0.2685    0.2893  -0.1299   -0.2388   -0.1635   -0.0476    0.0797;
%                      0.2171    0.3450    0.2975    0.2685    0.2893  -0.1299   -0.2388   -0.1635   -0.0476    0.0797];
AC.Wing.Airfoils = CST;

AC.Wing.eta = [0;1];  % Spanwise location of the airfoil sections

% Viscous vs inviscid
AC.Visc  = 1;              % 0 for inviscid and 1 for viscous analysis

% Flight Condition
AC.Aero.V     = V;            % flight speed (m/s)
AC.Aero.rho   = rho;          % air density  (kg/m3)
AC.Aero.alt   = alt;             % flight altitude (m)
AC.Aero.Re    = Re;        % reynolds number (based on mean aerodynamic chord)
AC.Aero.M     = M;           % flight Mach number 
AC.Aero.CL    = CL;          % lift coefficient - comment this line to run the code for given alpha%
%AC.Aero.Alpha = 2;             % angle of attack -  comment this line to run the code for given cl 

%Run Q3D
Res = Q3D_solver(AC);

%%Plot of spanwise drag distribution for Cruise Conditions 

Yst_original = [0.4375, 1.3125, 2.1875, 3.0625, 3.9375, 4.8125, 5.745, 6.735, 7.725, 8.715, 9.705, 10.695, 11.685, 12.675];
Y_section_original = [0	1.88142857142857	3.76285714285714	5.64428571428571	7.52571428571429	9.40714285714286	11.2885714285714	13.1700000000000];
Cdi_original = [0.0242 0.0212 0.0187 0.0162 0.0138 0.0113 0.0094 0.008 0.0067 0.0055 0.0045 0.0038 0.0036 0.0048];
Cd_wp_original = [0.00815521202298894, 0.00813098943781581, 0.00747140131850161, 0.00662576596947859, 0.00639008512427622, 0.00639007182314240, 0.00683690260393108, 0.00719597343206215];

plot(Res.Wing.Yst/(x(31)/2), Res.Wing.cdi, "b")
hold on
plot((Res.Section.Y/(x(31)/2)).', Res.Section.Cd)
hold on 
plot(Yst_original/(xref(31)/2), Cdi_original, 'r')
hold on
plot(Y_section_original/(xref(31)/2), Cd_wp_original)
hold on 
title('Spanwise Drag Distribution at Design Point')
xlabel('Normalized Span [-]')
ylabel('Drag Coefficient [-]')
legend('Final Induced Drag', 'Final Profile + Wave Drag', 'Initial Induced Drag', 'Initial Profile + Wave Drag')
f = gcf;
exportgraphics(f, '4_DragDistribution.png', 'Resolution', 300);
figure()

%%Plot of spanwise lift distribution for Cruise Conditions 
Yst_original = [0.4375, 1.3125, 2.1875, 3.0625, 3.9375, 4.8125, 5.745, 6.735, 7.725, 8.715, 9.705, 10.695, 11.685, 12.675, xref(31)/2];
ccl_original = [2.369, 2.3561, 2.2991, 2.2157, 2.1136, 1.9977, 1.8764, 1.7531, 1.6213, 1.4798, 1.3271, 1.1592, 0.9657, 0.7092, 0];

plot([Res.Wing.Yst/(x(31)/2); 1], [Res.Wing.ccl; 0], 'b')
hold on
plot(Yst_original/(xref(31)/2), ccl_original, 'r')
title('Spanwise lift distribution (c*C_l) at Design Point')
xlabel('Normalized Span [-]')
ylabel('Lift Coefficient * Local Chord [m]')
legend('Final', 'Initial')
f = gcf;
exportgraphics(f, '5_LiftDistributionCruise.png', 'Resolution', 300);
figure()

%% Spanwise lift distributions CRITICAL conditions 
WAW = 9.81*data.WAW; %[N] 
V = data.a*0.73; %[m/s]
rho = 0.475448; %[kg/m^3]
alt = 8839.2; %[m]
a = data.a; %[m/s]
dynvis = data.dynvis; %[Pa s]

%Flight Conditions 
Re = ((S/b)*rho*V)/dynvis;
M = V/a;
CL = Wdes/(0.5*rho*V^2*S);

%% Aerodynamic solver for Spanwise Lift Distribution in CRITICAL Conditions
% Wing planform geometry 
%                x    y     z   chord(m)    twist angle (deg) 
AC.Wing.Geom = [0     0     0     c1         0;
                x2    y2   z2     c2       theta2;
                x3    y3   z3     c3       theta3];

% Wing incidence angle (degree)
AC.Wing.inc  = 0;   
            
% Airfoil coefficients input matrix
%                    | ->     upper curve coeff.                <-|   | ->       lower curve coeff.       <-| 
%AC.Wing.Airfoils   = [0.2171    0.3450    0.2975    0.2685    0.2893  -0.1299   -0.2388   -0.1635   -0.0476    0.0797;
%                      0.2171    0.3450    0.2975    0.2685    0.2893  -0.1299   -0.2388   -0.1635   -0.0476    0.0797];
AC.Wing.Airfoils = CST;

AC.Wing.eta = [0;1];  % Spanwise location of the airfoil sections

% Viscous vs inviscid
AC.Visc  = 1;              % 0 for inviscid and 1 for viscous analysis

% Flight Condition
MTOW = Wwing + Wfuel + WAW;   %[N]
AC.Aero.V     = V;            % flight speed (m/s)
AC.Aero.rho   = rho;          % air density  (kg/m3)
AC.Aero.alt   = alt;             % flight altitude (m)
AC.Aero.Re    = Re;        % reynolds number (based on mean aerodynamic chord)
AC.Aero.M     = M;           % flight Mach number 
n_max = 2.5;
AC.Aero.CL    = (n_max*MTOW)/(0.5*AC.Aero.rho*AC.Aero.V^2*S);         % lift coefficient - comment this line to run the code for given alpha%
%AC.Aero.Alpha = 2;             % angle of attack -  comment this line to run the code for given cl 

%Run Q3D
Res_crit = Q3D_solver(AC);

%%Plot of spanwise lift distribution for CRITICAL Conditions 
Yst_original = [0.4375, 1.3125, 2.1875, 3.0625, 3.9375, 4.8125, 5.745, 6.735, 7.725, 8.715, 9.705, 10.695, 11.685, 12.675, (xref(31)/2)];
ccl_original_crit = [6.2418, 6.2496, 6.1745, 6.0448, 5.8714, 5.6615, 5.422, 5.1506, 4.846, 4.5051, 4.1197, 3.6697, 3.1035, 2.2556, 0];

plot([Res_crit.Wing.Yst/(x(31)/2); 1] , [Res_crit.Wing.ccl; 0], "b")
hold on 
plot(Yst_original/(xref(31)/2), ccl_original_crit, "r")
title('Spanwise lift distribution (c*C_l) at Critical Conditions')
xlabel('Normalized Span [-]')
ylabel('Lift Coefficient * Local Chord [m]')
legend('Final', 'Initial')
f = gcf;
exportgraphics(f, '6_LiftDistributionCritical.png', 'Resolution', 300);
figure()