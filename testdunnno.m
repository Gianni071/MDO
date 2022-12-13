clc
clear all
close all

CST_up_root    = x[1] x[2] x[3] x[4] x[5] x[6];
CST_lower_root = x[7] x[8] x[9] x[10] x[11] x[12];
CST_up_tip     = x[13] x[14] x[15] x[16] x[17] x[18];
CST_lower_tip  = x[19] x[20] x[21] x[22] x[23] x[24];

CST = [CSTroot; CSTtip];
x = [CST;3.94;0.75;0.475;0;0;17.82;26.21;5000;10023;16];

RootUp = transpose(x(1:6));
RootLow = transpose(x(7:12));
TipUp = x(13:18);
TipLow = x(19:24);

xairfoil = transpose(linspace(0,1,101));

[Xtu,Xtl] = D_airfoil2(RootUp,RootLow,xairfoil);

[Xtu_root, Xtl_root] = D_airfoil2(CST_up_root, CST_lower_root, [0, 0.25, 0.5, 0.75, 1]');
[Xtu_tip, Xtl_tip] = D_airfoil2(CST_up_tip, CST_lower_tip, [0, 0.25, 0.5, 0.75, 1]');