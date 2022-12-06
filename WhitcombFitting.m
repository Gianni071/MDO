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
Diff