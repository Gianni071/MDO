clc
clear all
close all

CSTroot = readmatrix('RootRefCST.txt');
CSTtip = readmatrix('TipRefCST.txt');

CST = [CSTroot;CSTtip];
x = [CST;3.94;0.75;0.475;0;0;17.82;26.21;5000;10023;16];
c1 = x(25);
c2 = c1*x(26);
c3 = c2*x(27);


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
for i = 11:30
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
for i = 11:30
    tn = XtuMid(i,2) - XtlMid(i,2);
    tn1 = XtuMid(i+1,2) - XtlMid(i+1,2);
    Ai = dx2*(tn+tn1)/2;
    A2 = A2 + Ai;
end


%Outboard unit airfoil coordinates
[Xtutip,Xtltip] = D_airfoil2(TipUp,TipLow,xairfoil);

