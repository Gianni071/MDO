%%Obtain the Original design variable matrix 
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

matobj = matfile("iterationdata.mat");

xnor = matobj.x;

CSTroot = readmatrix('RootRefCST.txt');
CSTtip = readmatrix('TipRefCST.txt');
CST = [CSTroot; CSTtip];

xref = [CST; 4.128; 0.75; 0.522; 100; 100; 17.82; 26.34;  4774.7 ; 10553.734; 15];
data.xref = xref;
x = xref;

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
Res_original = Q3D_solver(AC);

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
Res_original_crit = Q3D_solver(AC);
