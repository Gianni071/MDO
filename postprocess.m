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

%%__Plot the Wing in 3D__%%
scatter3(Xtl_tip(:,1), Xtl_tip(:,2), xref(31)*ones(1, 101)')
hold on
scatter3(Xtu_tip(:,1), Xtu_tip(:,2), xref(31)*ones(1, 101)')
hold on 
scatter3(Xtl_root(:,1), Xtl_root(:,2), 0.*ones(1, 101)')
hold on
scatter3(Xtu_root(:,1), Xtu_root(:,2), 0.*ones(1, 101)')
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

%%Plot of spanwise lift/drag distribution for Cruise Conditions 
plot(Res.Wing.Yst, Res.Wing.cdi)
hold on
plot(Res.Section.Y, Res.Section.Cd.')
figure()

plot(Res.Wing.Yst, Res.Wing.cl)
figure()

plot(Res.Wing.Yst, Res.Wing.ccl) %%Should end on 0 right?
Res.CLwing
hold on

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
Res = Q3D_solver(AC);

%%Plot of spanwise lift distribution for CRITICAL Conditions 
plot(Res.Wing.Yst, Res.Wing.ccl) %%Should end on 0 right?
Res.CLwing
figure()

plot(Res.Wing.Yst, Res.Wing.cl)