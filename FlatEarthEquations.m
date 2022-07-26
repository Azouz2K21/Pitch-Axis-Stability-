
function X_dot = StabilityAxesModel(X, inputs)
VT = X(1);
alpha = X(2);
theta = X(3);
Q = X(4);
beta = X(5);
phi = X(6);
P = X(7);
R = X(8);
psi = X(9);

Phi = [phi; theta; psi];
omega = [P; Q; R];

deltaT1 = inputs(1);
deltaT2 = inputs(2);
deltaA = inputs(3);
deltaE = inputs(4);
deltaR = inputs(5);

%% intermediate variables


rho = 1.225;
gD = 9.81;

cbar = 6.6;
S = 260;
l = 6.6;
St = 64;
lt = 24.8;
alpha0 = -11.5*(pi/180);

m = 120000;
J = m * [40.07 0 -2.0923; 0 64 0; -2.0923 0 99.92];
Jinv = (1/m) * [0.0249836 0 0.000523151; 0 0.015625 0; 0.000523151 0 0.010019];
cm = [0.23 * cbar; 0; 0.1 * cbar];
ac = [0.12 * cbar; 0; 0];
apt1 = [0; -7.94; -1.9];
apt2 = [0; 7.94; -1.9];

U = VT*(cos(alpha))*(cos(beta));
V = VT*sin(beta);
W = VT*(sin(alpha))*(cos(beta));

v = [U; V; W];
%VT_dot = ((U*U_dot)+(U*U_dot)+(U*U_dot))/(VT);

qbar = 0.5 * rho * VT ^ 2;
epsilon = 0.25 * (alpha - alpha0);
alpha_t = alpha - epsilon + deltaE + 1.3 * Q * lt / VT;

%% gravity effects
FG = m * [-gD * sin(theta); gD * cos(theta) * sin(phi); gD * cos(theta) * cos(phi)];

%% engine effects
% engine forces
engineThrust1 = deltaT1 * m * gD;
engineThrust2 = deltaT2 * m * gD;

FT1 = [engineThrust1; 0; 0];
FT2 = [engineThrust2; 0; 0];
FT = FT1 + FT2;

MT1 = cross(cm-apt1, FT1);
MT2 = cross(cm-apt2, FT2);

MT = MT1 + MT2;

%% aerodynamic effects
% aerodynamic forces
% lift coefficient
CL_wb = 5.5 * (alpha - alpha0);
CL_t = 3.1 * (St / S) * alpha_t;
CL = CL_wb + CL_t;

% drag coefficient
CD = 0.13 + 0.07 * (5.5 * alpha + 0.654) ^ 2;

% sideforce coefficient
CC = -1.6 * beta + 0.24 * deltaR;

% forces in wind axes system
drag = CD * qbar * S;
crosswind = CC * qbar *S;
lift = CL * qbar * S;
FA_w = [-drag; -crosswind; -lift];

% wind to body axes systems DCM
C_bf_w = [cos(alpha)*cos(beta), -cos(alpha)*sin(beta), -sin(alpha);sin(beta), cos(beta),0; sin(alpha)*cos(beta), -sin(alpha)*sin(beta), cos(alpha)];

% forces in body axes system
FA = C_bf_w * FA_w;

% aerodynamic moments
% calculating moement coefficients
temp1 = [-1.4*beta; -0.59-3.1*(St*lt)/(S*l)*(alpha - epsilon);(1-alpha*3.8197)*beta];
temp2 = (l / VT) * [-11, 0, 5; 0, -4.03*St*lt^2/(S*l^2), 0; 1.7, 0, -11.5];
temp3 = [-0.6, 0, 0.22; 0, -3.1*St*lt/(S*l), 0; 0, 0, -0.63];
temp4 = temp1 + temp2 * omega + temp3 * [deltaA; deltaE; deltaR];
MA_ac = temp4 * qbar * S * cbar;

% calculating moments around cm
MA = MA_ac + cross(FA, cm-ac);

%% flat-Earth equations
% force equation
F = FG + FT + FA;
v_dot = F/m - cross(omega, v);
U_dot = v_dot(1);
V_dot = v_dot(2);
W_dot = v_dot(3);

VT_dot = ((U*U_dot)+(V*V_dot)+(W*W_dot))/(VT);
alpha_dot = (U*W_dot -W*U_dot)/((U^2)+(W^2));
beta_dot = ((VT*V_dot)-(V*VT_dot))/(VT^2*(sqrt(1-(V/VT)^2)));


% moment equation
M = MT + MA;
omega_dot = Jinv * (M - cross(omega, J * omega));
omega_dot = -alpha_dot*[-R;0;P] + omega_dot;

P_dot= omega_dot(1);
Q_dot = omega_dot(2);
R_dot = omega_dot(3);

% kinematical equation
H_phi = [1 sin(phi)*tan(theta) cos(phi)*tan(theta); 0 cos(phi) -sin(phi); 0 sin(phi)/cos(theta) cos(phi)/cos(theta)];
Phi_dot = H_phi * omega;

phi_dot = Phi_dot(1);
theta_dot = Phi_dot(2);
psi_dot = Phi_dot(3);

X_dot = [VT_dot; alpha_dot; theta_dot; Q_dot; beta_dot; phi_dot; P_dot; R_dot; psi_dot];

end