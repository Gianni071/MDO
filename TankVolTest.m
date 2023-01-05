clc
clear all
close all

CSTroot = readmatrix('RootRefCST.txt');
CSTtip = readmatrix('TipRefCST.txt');

y2 = 5.25; %Fix global
Vaux = 1.174; %Fix global
CST = [CSTroot;CSTtip];
x = [CST;4.128;0.75;0.522;0;0;17.82;26.34;5000;10107.95;16];
c1 = x(25);
c2 = c1*x(26);
c3 = c2*x(27);
y3 = x(31)/2;
Wfuel = x(33); %[kg]
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
for i = 9:30
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
for i = 9:30
    tn = XtuMid(i,2) - XtlMid(i,2);
    tn1 = XtuMid(i+1,2) - XtlMid(i+1,2);
    Ai = dx2*(tn+tn1)/2;
    A2 = A2 + Ai;
end


%Outboard unit airfoil coordinates
[Xtutip,Xtltip] = D_airfoil2(TipUp,TipLow,xairfoil);

%Calculate c85 (85% semi-span) based on planform
c85 = (c3-c2)/(y3-y2)*(0.85*y3 - y2) + c2;

%85% span airfoil coordinates
Xtutip = c85*Xtutip;
Xtltip = c85*Xtltip;

dx3 = Xtutip(2,1) - Xtutip(1,1);
A3 = 0;

%Loop to calculate cross-sectional area
for i = 9:30
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
Vout = Aout*(0.85*y3 - y2);

%Total volume of wing fuel tank:
Vtot = 0.93*2*(Vin+Vout);

%Calculate constraint
Vreq = Wfuel/rhofuel;
con2 = Wfuel/rhofuel - Vaux - Vtot;
