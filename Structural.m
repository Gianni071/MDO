function[W_wing] = Structural(x, RJ85.init, RJ85.load)

EMWET('RJ85')

filename = 'RJ85.weight';
delimiterIn = ' ';
headerlinesIn = 4;
A = importdata(filename, delimiterIn, headerlinesIn);
B = A.textdata{1, 1}(23:29)

W_wing = B