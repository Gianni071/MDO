function[fval,c,ceq] = IterationCheckFunction(x)


fval = objective(x);

[c,ceq] = constraints(x);

