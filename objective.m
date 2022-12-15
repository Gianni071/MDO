function [f] = objective(x)

global data

loads(x,0)
Structural(x)

%Design Vector Entries:
%x = [CST,c1,lambda1,lambda2,theta2,theta3,LEsw,b,Wwing,Wfuel,L/DcrAC]
%x = [1-24,25, 26      27      28     29    30  31  32    33     34]

f = x(32) + x(33) + data.WAW;

end