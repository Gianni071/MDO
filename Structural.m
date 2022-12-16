function[W_wing] = Structural()

EMWET('RJ85')

fid = fopen('RJ85.weight', 'r');
A = fgetl(fid);
A1 = split(A, " ");
W_str = str2double(A1(4));

W_wing = W_str;
data.Wwing = W_wing;