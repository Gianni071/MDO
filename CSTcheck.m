%CST bounds check file
clc
clear all
close all

%Xcoords of airfoil
t = readmatrix('RootAirfoil.txt');
Xcoords = t(1:length(t)/2,1);

%Root bounds
rootCST = readmatrix('RootRefCST.txt');

%Calculate absolute 20% change
absrootCST = abs(rootCST);
abschange = 0.25*absrootCST;

lbroot = rootCST - abschange;
ubroot = rootCST + abschange;

%create limit CST values (upper -> lowest CST, lower -> highest CST)
rootuplimit = lbroot(1:6);
rootlowlimit = ubroot(7:12);

%Calculate coordinates of limit airfoil
[Xturoot,Xtlroot] = D_airfoil2(rootuplimit,rootlowlimit,Xcoords);

Yuroot = Xturoot(:,2)
Ylroot = Xtlroot(:,2)

%plot airfoil
figure
hold on
plot(Xcoords,Yuroot,'b')
plot(Xcoords,Ylroot,'r')
axis([0,1,-0.3,0.3])
%Tip bounds
tipCST = readmatrix('TipRefCST.txt')

%Calculate absolute 20% change
abstipCST = abs(tipCST);
abschangetip = 0.25*abstipCST;

lbtip = tipCST - abschangetip;
ubtip = tipCST + abschangetip;

%create limit CST values (upper -> lowest CST, lower -> highest CST)
tipuplimit = lbtip(1:6);
tiplowlimit = ubtip(7:12);

%Calculate coordinates of limit airfoil
[Xtutip,Xtltip] = D_airfoil2(tipuplimit,tiplowlimit,Xcoords);

Yutip = Xtutip(:,2)
Yltip = Xtltip(:,2)

%plot airfoil
figure
hold on
plot(Xcoords,Yutip,'b')
plot(Xcoords,Yltip,'r')
axis([0,1,-0.3,0.3])

lb = [lbroot;lbtip]
ub = [ubroot;ubtip]

writematrix(lb,'CSTLowerBound.txt')
writematrix(ub,"CSTUpperBound.txt")