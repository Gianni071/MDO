clc
clear all
close all

matobj = matfile("TestWorkspace.mat");


outputfcn = matobj.outputFcn_global_data;

out1 = outputfcn(1,2);
out2 = outputfcn(1,3);
out3 = outputfcn(1,4);

x1 = out1.x
x2 = out2.x