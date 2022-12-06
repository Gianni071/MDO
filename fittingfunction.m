%Fitting function used in WhitcombFitting.m
function[error] = fittingfunction(x)

%Read .dat file
txt = readmatrix('TipAirfoil.txt');

%Read CST coefficients
CSTup = x(1:length(x)/2);
CSTlow = x(length(x)/2+1:length(x));

k = length(txt)/2;
%Reference airfoil coordinates
Xcoords = txt(1:k,1);
Yu = txt(1:k,2);
Yl = txt(k+1:length(txt),2);

%Class function coordinates
[Xtu,Xtl] = D_airfoil2(CSTup,CSTlow,Xcoords);


errorup = sum((Xtu(:,2)-Yu).^2);
errorlow = sum((Xtl(:,2)-Yl).^2);

error = errorup+errorlow;