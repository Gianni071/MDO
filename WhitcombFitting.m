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
YlRoot = CoordDown*scalefactor8;

%X-coords
Xairfoil = t(k:length(t),1);
