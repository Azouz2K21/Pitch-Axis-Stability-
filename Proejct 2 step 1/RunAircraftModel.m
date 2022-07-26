clear
clc
close all

%% initial conditions
%states
pN0 = 0;
pE0 = 0;
h0 =39370.079*0.3048;
phi0 =0;
theta0 = 5.72958*pi/180;
psi0 = 0;
U0 = 306/3.6;
V0 = 0;
W0 =0; 
P0 = 0;
Q0 = 0;
R0 = 0;

% build the state vector intial conditions
X0 = [pN0; pE0; h0; phi0; theta0; psi0; U0; V0; W0; P0; Q0; R0];

% inputs
deltaT1 = 4.583662*pi/180;
deltaT2 = 4.583662*pi/180;
deltaA = 0;
deltaE = -5.72958*pi/180;
deltaR = 0;

%simulation time
simTim = 50;

%% Run the model
out = sim("AircraftModel.slx");

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
x10 = out.simX.Data(:,10);
x11 = out.simX.Data(:,11);
x12 = out.simX.Data(:,12);

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
legend('pN')
grid on
subplot(4,3,2)
plot(t,x2)
legend('pE')
grid on
subplot(4,3,3)
plot(t,x3)
legend('h')
grid on
subplot(4,3,4)
plot(t,x4)
legend('phi')
grid on
subplot(4,3,5)
plot(t,x5)
legend('theta')
grid on
subplot(4,3,6)
plot(t,x6)
legend('psi')
grid on
subplot(4,3,7)
plot(t,x7)
legend('U')
grid on
subplot(4,3,8)
plot(t,x8)
legend('V')
grid on
subplot(4,3,9)
plot(t,x9)
legend('W')
grid on
subplot(4,3,10)
plot(t,x10)
legend('P')
grid on
subplot(4,3,11)
plot(t,x11)
legend('Q')
grid on
subplot(4,3,12)
plot(t,x12)
legend('R')
grid on