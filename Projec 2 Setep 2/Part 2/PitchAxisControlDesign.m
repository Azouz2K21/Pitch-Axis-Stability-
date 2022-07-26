clear
close all
clc

A = load('Along.mat');
A= A.A_Long;
B = load('Blong.mat');
B=B.B_long(:,3);

C = [0.000000E+00, 1, 0.000000E+00, 0.000000E+00;
     0.000000E+00, 0.000000E+00, 0.000000E+00, 1];

aa = [          A,    -B;
       zeros(1,4),    1/15];

ba = [zeros(4,1); 1/15];

ca = [         C,  zeros(2,1)];


sys = ss(aa,ba,ca(1,:),0);


rlocus(sys)

[num,den] = ss2tf(aa,ba,ca(1,:),0);

k_alpha = 33.5;


acl = aa - ba * k_alpha * ca(1,:); % dynamics of inner loop

sys1 = ss(acl,ba,ca(2,:),0);
figure;
rlocus(sys1);
[num1,den1]=ss2tf(acl,ba,ca(2,:),0);
%k_alpha = 34;