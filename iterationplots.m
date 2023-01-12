clc
clear all
close all

matobj = matfile('iterationplots.mat');

carray = matobj.carray;
ceqarray = matobj.ceqarray;
fvalarray = matobj.fvalarray;

iterationarray = linspace(0,length(carray)-1,length(carray));
%Plot inequality
plot(iterationarray,carray(1,:),'b')
hold on
plot(iterationarray,carray(2,:),'r')
hold off
legend('Wing Loading','Fuel Tank Volume')
grid()
figure()

%Plot Equality
plot(iterationarray,ceqarray(1,:),'b')
hold on
plot(iterationarray,ceqarray(2,:),'r')
plot(iterationarray,ceqarray(3,:),'g')
hold off
legend('Fuel Weight','Wing Weight','L/D')
grid()
figure()

%Plot Fval
plot(iterationarray,fvalarray,'b')
grid()
