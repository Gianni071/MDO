clc
close all
clear all

%% Define Constants
global data

%Fuselage drag
data.Dfus = 12006.92; %[N]

%Reference planform values
data.x1 = 0; %[m]
data.y1 = 0; %[m]
data.z1 = 0; %[m]
data.y2 = 5.25; %[m]
data.z2 = -0.458; %[m]
data.TEsw = 6.15; %[deg]
data.dihedral = -5; %[deg]
data.Sref = 77.3; %[m^2]
data.Vaux = 1.174; %[m^3]

%Change this!
data.WAW = 30951.45; %[kg] ZFW - Wing weight 
data.WSref = 545.72; %[kg/m^2]
data.MTOWref = 45857; %[kg]

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
data.rear_spar   =    0.62;      %[-]
data.ftank_start =    0.1;     %[y/y3]
data.ftank_end   =    0.85;    %[y/y3]
data.eng_num     =    2;       %[-]
data.eng_ypos1   =    0.315;   %[y/y3]
data.eng_ypos2   =    0.50;    %[y/y3]

%% Initial Design Vector
%Design Vector Entries:
%x = [CST,c1,lambda1,lambda2,theta2,theta3,LEsw,b,Wwing,Wfuel,L/DcrAC]
%x = [1-24,25, 26      27      28     29    30  31  32    33     34]

%Get initial CST coefficients
CSTroot = readmatrix('RootRefCST.txt');
CSTtip = readmatrix('TipRefCST.txt');
CST = [CSTroot; CSTtip];

xref = [CST; 3.94; 0.75; 0.475; 100; 100; 17.82; 26.21;  4882.55 ; 10023; 16];
data.xref = xref;
x0 = xref./xref;
%% Bounds Vectors
CSTlb = readmatrix('CSTLowerBound.txt');
CSTub = readmatrix('CSTUpperBound.txt');

%Lower Bound 
lb = [CSTlb; 3.152; 0.6; 0.38; 85; 85; 10; 20.96; 3906.04; 8018; 11.2];
lb = lb./xref;
%Upper Bound
ub = [CSTub; 4.728; 0.9; 0.57; 115; 115; 25; 31.44; 5859.06; 12027; 20.8];
ub = ub./xref;


%%_Calling on FMINCON to run Optimization_%%
%OPTIONS
options.Display         = 'iter';
options.Algorithm       = 'sqp';
options.FunValCheck     = 'off';
options.DiffMinChange   = 1e-2;         % Minimum change while gradient searching
options.DiffMaxChange   = 5e-1;         % Maximum change while gradient searching
options.TolCon          = 1e-4;         % Maximum difference between two subsequent constraint vectors [c and ceq]
options.TolFun          = 1e-3;         % Maximum difference between two subsequent objective value
options.TolX            = 1e-3;         % Maximum difference between two subsequent design vectors
options.PlotFcns = {@optimplotfval, @optimplotx, @optimplotfirstorderopt};
options.ScaleProblem = 'false';

%FMINCON
tic
[x,fval,exitflag,output] = fmincon(@objective, x0, [], [], [] , [], lb, ub, @constraints , options);
toc

x_opt = x;
fun_opt = fval;

