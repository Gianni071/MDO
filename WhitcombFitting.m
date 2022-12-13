%This script calculates the CST coefficients for the Whitcomb airfoil
clc
clear all
close all
%Check Thickness of original Whitcomb

t = readmatrix('withcomb135.dat');

lim = length(t);
%Check for x=0
for i= 1:lim;
      if t (i,2) == 0;
          k = i;
        break;
end
end

%Upper surface coords
CoordUp = t(1:k,2);
CoordDown = t(k:length(t),2);

%Difference between upper and lower coordinates
diff = CoordUp-CoordDown;
%Max thickness (chord=1 so immediately (t/c)max)
maxt = max(diff);

%Scale factor for 14%:
scalefactor14 = 0.14/maxt;
%Scale factor for 8%:
scalefactor8 = 0.08/maxt;

%Root airfoil Y-coordinates
YuRoot = CoordUp*scalefactor14;
YlRoot = CoordDown*scalefactor14;

%Tip airfoil Y-coordinates
YuTip = CoordUp*scalefactor8;
YlTip = CoordDown*scalefactor8;

%X-coords
Xairfoil = t(k:length(t),1);

%Create Root and Tip .dat files and write
%RootMatrix1 = [Xairfoil,YuRoot];
%RootMatrix2 = [Xairfoil,YlRoot];
%RootMatrix = [RootMatrix1;RootMatrix2];

%writematrix(RootMatrix,"RootAirfoil.txt")

%TipMatrix1 = [Xairfoil,YuTip]
%TipMatrix2 = [Xairfoil,YlTip]
%TipMatrix = [TipMatrix1;TipMatrix2]

%writematrix(TipMatrix,'TipAirfoil.txt')

%Fmincon setup
Npar = 12;
x0 = zeros(Npar,1);
lb = -1*ones(Npar,1);
ub = ones(Npar,1);
option = optimset('display','iter','algorithm','sqp');

%Run fmincon
[x,fval,exitflag,output] = fmincon(@fittingfunction,x0,[],[],[],[],lb,ub,[],option);

%Extract Coordinates of CST airfoil
CSTup = x(1:length(x)/2);
CSTlow = x(length(x)/2+1:length(x));
[Xtl,Xtu] = D_airfoil2(CSTup,CSTlow,Xairfoil);

%extract coordinates of .txt airfoil
txt = readmatrix('RootAirfoil.txt');
k = length(txt)/2;
%Reference airfoil coordinates
Xcoords = txt(1:k,1);
Yuref = txt(1:k,2);
Ylref = txt(k+1:length(txt),2);

Yu = Xtu(:,2);
Yl = Xtl(:,2);

hold on;
plot(Xairfoil,Yu,'b');
plot(Xairfoil,Yl,'b');
plot(Xairfoil,Yuref,'rx')
plot(Xairfoil,Ylref,'rx')

axis([0,1,-0.3,0.3]);

%Write CST coeff as txt
%writematrix(x,"TipRefCST.txt")
%writematrix(x,'RootRefCST.txt');
