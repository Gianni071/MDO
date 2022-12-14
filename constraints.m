function[c,ceq] = constraints(x)
%% Get outputs from other blocks
global data
CL = data.CL;
CD = data.CD;
Wwing = data.Wwing;
Wfuel = data.Wfuel;
Dfus = data.Dfus;
rho = data.rho;
Vcr = data.Vcr;
V = Vcr*0.51444;
y2 = data.y2;
WAW = data.WAW;
WSref = data.WSref; %[kg/m^2]
Vaux = data.Vaux; %[m^3]

%% Get design vector variables and computed variables
%Design Vector Entries:
%x = [CST,c1,lambda1,lambda2,theta2,theta3,LEsw,b,Wwing,Wfuel,L/DcrAC]
%x = [1-24,25, 26      27      28     29    30  31  32    33     34]

CST = x(1:24);
c1 = x(25);
lambda1 = x(26);
lambda2 = x(27);
b = x(31);
Wwinghat = x(32);
Wfuelhat = x(33);
LDhat = x(34);

y3 = b/2;
c2 = lambda1*c1;
c3 = lambda2*c2;

%% Consistency 1
ceq1 = Wfuelhat - Wfuel;

%% Consistency 2
ceq2 = Wwinghat - Wwing;

%% Consistency 3
S = 2*(y2*(c1+c2)/2+(y3-y2)*(c2+c3)/2);
L = CL*0.5*rho*V^2*S;
D = CD*0.5*rho*V^2*S + Dfus;
LD = L/D;

ceq3 = LDhat - LD;

ceq = [ceq1;ceq2;ceq3];

%% Inequality 1
WTO = Wfuel+Wwing+WAW;

WScalc = WTO/S;

c1 = WScalc - WSref;

%% Inequality 2

