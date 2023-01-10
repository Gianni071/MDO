clc
clear all
close all

matobj = matfile("TestWorkspace.mat");


outputfcn = matobj.outputFcn_global_data;

out1 = outputfcn(1,1);
out2 = outputfcn(1,3);

x1 = out1.x
x2 = out2.x