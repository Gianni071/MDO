clc
clear all
close all

CST_root    = [0.1621 0.2506 -0.05801 0.4901 0.01004 0.7148 -0.2468 -0.1792 -0.05085 -0.5233 0.08111 0.3562];
CST_tip     = [0.09264 0.1434 -0.03347 0.2805 0.005353 0.4087 -0.1410 -0.1025 -0.02887 -0.2992 0.04652 0.2034];

RootUp = transpose(CST_root(1:6));
RootLow = transpose(CST_root(7:12));
TipUp = CST_tip(1:6);
TipLow = CST_tip(7:12);

xairfoil = transpose(linspace(0,1,101));

[Xtu_root, Xtl_root] = D_airfoil2(RootUp, RootLow, xairfoil);
[Xtu_tip, Xtl_tip] = D_airfoil2(TipUp, TipLow, xairfoil);

fid = fopen('RootAirfoil.txt','wt');
fprintf(fid, '%f %f \n', Xtu_root');
fprintf(fid, '%f %f \n', Xtl_root');
fclose(fid)

fid = fopen('TipAirfoil.txt','wt');
fprintf(fid, '%f %f \n', Xtu_tip');
fprintf(fid, '%f %f \n', Xtl_tip');
fclose(fid)