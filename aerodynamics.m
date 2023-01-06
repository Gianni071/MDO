function[CL,CD] = aerodynamics(x,vis)
%% Get Inputs
global data
%Design Vector Entries:
%x = [CST,c1,lambda1,lambda2,theta2,theta3,LEsw,b,Wwing,Wfuel,L/DcrAC]
%x = [1-24,25, 26      27      28     29    30  31  32    33     34]
x = x.*data.xref;
%Constant variables (TAKE THIS FROM GLOBAL WHEN ACTUALLY RUNNING)
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

%% Aerodynamic solver setting

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
AC.Visc  = vis;              % 0 for inviscid and 1 for viscous analysis

% Flight Condition
AC.Aero.V     = V;            % flight speed (m/s)
AC.Aero.rho   = rho;         % air density  (kg/m3)
AC.Aero.alt   = alt;             % flight altitude (m)
AC.Aero.Re    = Re;        % reynolds number (based on mean aerodynamic chord)
AC.Aero.M     = M;           % flight Mach number 
AC.Aero.CL    = CL;          % lift coefficient - comment this line to run the code for given alpha%
%AC.Aero.Alpha = 2;             % angle of attack -  comment this line to run the code for given cl 

%Run Q3D
Res = Q3D_solver(AC);

%Output CL and CD

CL = Res.CLwing;
CD = Res.CDwing;

data.CL = CL;
data.CD = CD;
