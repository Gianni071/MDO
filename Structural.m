function[W_wing] = Structural()

global data
EMWET('RJ85')

filename = 'RJ85.weight';
delimiterIn = ' ';
headerlinesIn = 4;
A = importdata(filename, delimiterIn, headerlinesIn);
B = A.textdata{1, 1}(23:-1);

W_wing = B;
W_wing = str2num(W_wing);
data.Wwing = W_wing;