clear
clc
close all

X_dot0 = zeros(9,1);

VT0 = 85;
alpha0 = 0;
beta0 = 0;
phi0 = 0;
theta0 = 0.1;
psi0 = 0;
P0 = 0;
Q0 = 0;
R0 = 0;
X0 = [VT0; alpha0; beta0; phi0; theta0; psi0; P0; Q0; R0];

deltaT10 = 0.08;
deltaT20 = 0.08;
deltaE0 = -0.1;
deltaA0 = 0;
deltaR0 = 0;
U0 = [deltaT10; deltaT20; deltaE0; deltaA0; deltaR0];

perturbationSize = 10e-5;
dx_dot = perturbationSize * ones(9,9);
dx = perturbationSize* ones(9,9);
du = perturbationSize * ones(9,9);

[E,A_implicit,B_implicit] = Linearize(@ImplicitStabilityAxesModel, X_dot0, X0, U0, dx_dot, dx, du);

A = -inv(E) * A_implicit;
B = -inv(E) * B_implicit;
