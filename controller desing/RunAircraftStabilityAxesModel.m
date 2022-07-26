clear
clc
close all

%% initial conditions
%states
VT0 = 85;
alpha0 = 0;
theta0 = 0.1;
Q0 = 0;
beta0 = 0;
phi0 = 0;
P0 = 0;
R0 = 0;
psi0 = 0;

X0 = [VT0; alpha0; theta0; Q0;beta0 ;phi0 ; P0; R0; psi0];

% inputs
deltaT1 = 0.08;
deltaT2 = 0.08;
deltaA = 0;
deltaE = -0.1;
deltaR = 0;

%simulation time
TF = 500;

%% Run the model
out = sim("alpha_open.slx");

t_1 = out.simX.Time;
u4_1 = out.simU.Data(:,4);
x2_1 = out.simX.Data(:,2);

out = sim("alpha_closed.slx");
t_2 = out.simX.Time;
u4_2 = out.simU.Data(:,4);
x2_2 = out.simX.Data(:,2);

figure 
plot(t_1,x2_1)
hold on
plot(t_2,x2_2)
legend('alpha - open loop','alpha - closed loop')
grid on
