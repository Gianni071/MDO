function[W_fuel] = Performance(x)

global data

%x = [CST,c1,lambda1,lambda2,theta2,theta3,LEsw,b,Wwing,Wfuel,L/DcrAC]
%x = [1-24,25, 26      27      28     29    30  31  32    33     34]

x = x.*data.xref;
Aircraft_Wing = data.WAW;
R = 3300.264*1000; %[km]
W_fuel = x(33);
W_wing = x(32);
LD = x(34);
C_T = 1.8639*10^(-4);
v = data.Vcr*0.51444;

MTOW = W_fuel + W_wing + Aircraft_Wing;

Ws_We = exp(R*(C_T/v)*(1/LD));

W_fuel = (1 - 0.938*(1/Ws_We))*MTOW;

data.Wfuel = W_fuel;