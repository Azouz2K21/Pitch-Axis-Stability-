clear
close all
clc

A = load('A_impl.mat');
A= A.A_implicit;
B = load('B_implicit.mat');
B=B.B_implicit(:,4);

C = [0.000000E+00, 1, 0.000000E+00, 0.000000E+00, 0.000000E+00, 0.000000E+00,0.000000E+00, 0.000000E+00,0.000000E+00;
     0.000000E+00, 0.000000E+00, 0.000000E+00, 1,0.000000E+00, 0.000000E+00, 0.000000E+00,0.000000E+00, 0.000000E+00];

aa = [          A,    -B;
       zeros(1,9),    1/15];

ba = [zeros(9,1); 1/15];

ca = [         C,  zeros(2,1)];


sys = ss(aa,ba,ca(1,:),0);


rlocus(sys)

[num,den] = ss2tf(aa,ba,ca(1,:),0);

k_alpha = 126;


acl = aa - ba * k_alpha * ca(1,:); % dynamics of inner loop

sys1 = ss(acl,ba,ca(2,:),0);
figure;
rlocus(sys1);
[num1,den1]=ss2tf(acl,ba,ca(2,:),0);
%k_alpha = 34;