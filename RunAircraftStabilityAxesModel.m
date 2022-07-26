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
TF = 50;

%% Run the model
out = sim("AircraftStabilityAxesModel.slx");

t = out.simX.Time;

u1 = out.simU.Data(:,1);
u2 = out.simU.Data(:,2);
u3 = out.simU.Data(:,3);
u4 = out.simU.Data(:,4);
u5 = out.simU.Data(:,5);

x1 = out.simX.Data(:,1);
x2 = out.simX.Data(:,2);
x3 = out.simX.Data(:,3);
x4 = out.simX.Data(:,4);
x5 = out.simX.Data(:,5);
x6 = out.simX.Data(:,6);
x7 = out.simX.Data(:,7);
x8 = out.simX.Data(:,8);
x9 = out.simX.Data(:,9);

figure
subplot(511)
plot(t,u1)
legend('deltaT1')
grid on
subplot(512)
plot(t,u2)
legend('deltaT2')
grid on
subplot(513)
plot(t,u3)
legend('deltaA')
grid on
subplot(514)
plot(t,u4)
legend('deltaE')
grid on
subplot(515)
plot(t,u5)
legend('deltaR')
grid on

figure 
subplot(4,3,1)
plot(t,x1)
legend('VT')
grid on
subplot(4,3,2)
plot(t,x2)
legend('alpha')
grid on
subplot(4,3,3)
plot(t,x3)
legend('theta')
grid on
subplot(4,3,4)
plot(t,x4)
legend('Q')
grid on
subplot(4,3,5)
plot(t,x5)
legend('beta')
grid on
subplot(4,3,6)
plot(t,x6)
legend('phi')
grid on
subplot(4,3,7)
plot(t,x7)
legend('P')
grid on
subplot(4,3,8)
plot(t,x8)
legend('R')
grid on
subplot(4,3,9)
plot(t,x9)
legend('psi')
grid on