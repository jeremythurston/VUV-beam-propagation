function [curvature,radius,q_var,Z] = propagation(q_var,N,L)
%ABCD computation of beam propagation in free space
global lambda_0

P=[1,L/N;0,1];               %propagation from laser to coupling lens

curvature=zeros(1,N);
radius=zeros(1,N);
Z=zeros(1,N);

for j=1:N
    q_var=(P(1,1)*q_var+P(1,2))/(P(2,1)*q_var+P(2,2));
    curvature(j)=1/real(1/q_var);
    radius(j)=sqrt(-lambda_0/(pi*imag(1/q_var)));
    Z(j)=j*L/N;
end

end

