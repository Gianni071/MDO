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
xref = data.xref;

%% Get design vector variables and computed variables
%Design Vector Entries:
%x = [CST,c1,lambda1,lambda2,theta2,theta3,LEsw,b,Wwing,Wfuel,L/DcrAC]
%x = [1-24,25, 26      27      28     29    30  31  32    33     34]
x = x.*xref;

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
ceq1 = Wfuelhat/Wfuel - 1;

%% Consistency 2
ceq2 = Wwinghat/Wwing - 1;

%% Consistency 3
S = 2*(y2*(c1+c2)/2+(y3-y2)*(c2+c3)/2);
L = CL*0.5*rho*V^2*S;
D = CD*0.5*rho*V^2*S + Dfus;
LD = L/D;

ceq3 = LDhat/LD - 1;

ceq = [ceq1;ceq2;ceq3];

%% Inequality 1 Wing Loading
WTO = Wfuel+Wwing+WAW;

WScalc = WTO/S;

con1 = WScalc/WSref - 1;

%% Inequality 2 Fuel Tank Volume
rhofuel = 0.81715*10^3; %[kg/m^3]

RootUp = transpose(x(1:6));
RootLow = transpose(x(7:12));
TipUp = transpose(x(13:18));
TipLow = transpose(x(19:24));

xairfoil = transpose(linspace(0,1,51));

%Root unit airfoil coordinates
[XtuRt,XtlRt] = D_airfoil2(RootUp,RootLow,xairfoil);

%Root section coordinates
XtuRoot = XtuRt*c1;
XtlRoot = XtlRt*c1;
%Root airfoil area
dx1 = XtuRoot(2,1)-XtuRoot(1,1);
A1 = 0;
for i = 9:31
    tn = XtuRoot(i,2) - XtlRoot(i,2);
    tn1 = XtuRoot(i+1,2) - XtlRoot(i+1,2);
    Ai = dx1*(tn+tn1)/2;
    A1 = A1 + Ai;
end

%Mid airfoil area
XtuMid = XtuRt*c2;
XtlMid = XtlRt*c2;
dx2 = XtuMid(2,1)-XtuMid(1,1);
A2 = 0;
for i = 9:31
    tn = XtuMid(i,2) - XtlMid(i,2);
    tn1 = XtuMid(i+1,2) - XtlMid(i+1,2);
    Ai = dx2*(tn+tn1)/2;
    A2 = A2 + Ai;
end


%Outboard unit airfoil coordinates
[Xtutip,Xtltip] = D_airfoil2(TipUp,TipLow,xairfoil);

%Calculate c85 (85% semi-span) based on planform
c85 = (c3-c2)/(y3-y2)*(0.9*y3 - y2) + c2;

%85% span airfoil coordinates
Xtutip = c85*Xtutip;
Xtltip = c85*Xtltip;

dx3 = Xtutip(2,1) - Xtutip(1,1);
A3 = 0;

%Loop to calculate cross-sectional area
for i = 9:31
    tn = Xtutip(i,2) - Xtltip(i,2);
    tn1 = Xtutip(i+1,2) - Xtltip(i+1,2);
    Ai = dx3*(tn+tn1)/2;
    A3 = A3 + Ai;
end

%Tank Volume is average cross-sectional area times span

%Inboard wing volume
%Average area:
Ain = (A1+A2)/2;

%Volume
Vin = Ain*y2;

%Outboard wing volume
%Average area:
Aout = (A2+A3)/2;

%Volume
Vout = Aout*(0.9*y3 - y2);

%Total volume of wing fuel tank:
Vtot = 0.93*2*(Vin+Vout);

%Calculate constraint
Vreq = Wfuelhat/rhofuel;
Vtot2 = Vaux + Vtot;
con2 = Vreq/Vtot2 - 1;

c = [con1;con2];
