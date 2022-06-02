function q_var = lens(f,q_var)
%ABCD computation of beam propagation through a thin lens

P=[1,0;-1/f,1];
q_var=(P(1,1)*q_var+P(1,2))/(P(2,1)*q_var+P(2,2));

end

