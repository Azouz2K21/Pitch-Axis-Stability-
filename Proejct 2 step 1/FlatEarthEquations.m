function X_dot = FlatEarthEquations(X, inputs)
%% State variables
% Make sure you are the order of state variables in the state vector is
% consistent everywhere.
pN = X(1);
pE = X(2);
h = X(3);
p = [pN; pE; h];

phi = X(4);
theta = X(5);
psi = X(6);
Phi = [phi; theta; psi];

U = X(7);
V = X(8);
W = X(9);
v = [U; V; W];

P = X(10);
Q = X(11);
R = X(12);
omega = [P; Q; R];

%% DCM 
% DCM matrix formula from page 12 
C_ned_to_frd = [cos(theta)*cos(psi), ...
                cos(theta)*sin(psi), ...
                -sin(theta); ...
                (-cos(phi)*sin(psi)+sin(phi)*sin(theta)*cos(psi)), ...
                (cos(phi)*cos(psi)+sin(phi)*sin(theta)*sin(psi)), ...
                sin(phi)*cos(theta); ...
                (sin(phi)*sin(psi)+cos(phi)*sin(theta)*cos(psi)), ...
                (-sin(phi)*cos(psi)+cos(phi)*sin(theta)*sin(psi)), ...
                cos(phi)*cos(theta)];
C_frd_to_ned = C_ned_to_frd';

%% 6-DOF flat Earth equations
% Kinematic equation
% h matrix formula 


%% Input variables
% Make sure you are the order of input variables in the inputs vector is
% consistent everywhere.
deltaT1 = inputs(1);
deltaT2 = inputs(2);
deltaA = inputs(3);
deltaE = inputs(4);
deltaR = inputs(5);

%% Intermediate variables
% This section is optional. You can use it to define all constants and
% frequently used variables like alpha and beta here. It just makes the
% code more readable.
c_bar = 6.6;
ac = [0.12*c_bar;0;0];
cm = [0.23*c_bar; 0 ; 0.1*c_bar];
apt_FT1 =  [0; -7.94; -1.9];
apt_FT2 =  [0; 7.94; -1.9];
m= 12000; 
S = 260;
S_t = 64;
l = 6.6;
l_t = 24.8;
alpha_0 = -11.5*pi/180;
roah = 1.225;
gD= 9.81; 
V_t = sqrt(U^2 + V^2 + W^2);
alpha = atan(W/U);

q = 0.5*roah*V_t^2;
beta = asin(V/V_t);
J = m*[40.07 0 -2.0923; 0 64 0; -2.0923 0 99.92];
Jinv = inv(J);

%% Gravity effects
% Calculate the gravity vector in the frd frame, then calculate weight and
% call it FG.
FG_ned = m*[0;0;gD];
FG = C_ned_to_frd*(FG_ned);

%% Engine effects
% Engine forces
engineThrust1 = deltaT1 * m * gD;
engineThrust2 = deltaT2 * m * gD;

% Build thrust vectors expressed in the frd frame and call them FT1 and
% FT2.
FT1  = [engineThrust1;0 ;0];
FT2  = [engineThrust2;0 ;0];

FT = FT1 + FT2;

% Once FT1 and FT2 are built, compute the moments due to the thrust of each
% engine and call them MT1 and MT2. 
d_T_1 = cm-apt_FT1; 
d_T_2 = cm-apt_FT2;


MT1 = cross(FT1,d_T_1);
MT2 = cross(FT2,d_T_2);
%MT1 = cross(d_T_1,FT1);
%MT2 = cross(d_T_2,FT2);

MT = MT1 + MT2;

%% Aerodynamic effects
% Aerodynamic forces
% Implement the formulas for the lift coefficient


C_l_wb = 5.5*(alpha - alpha_0);
epsilon = 0.25*(alpha - alpha_0);
alpha_t = alpha - epsilon + deltaE + 1.3*Q*(l_t/V_t);
C_l_t = 3.1 *(S_t/S)*alpha_t;

C_l = C_l_wb + C_l_t;
L = q*S*C_l;

% Drag coefficient
% Implement the formula for the drag coefficient
C_D = 0.13+(0.07*(5.5*alpha + 0.654)^2);
D = q*S*C_D;

% Crosswind coefficient
% Implement the formula for the crosswind force coefficient
C_c = -1.6*beta + 0.24*deltaR;
C = q*S*C_c;

% Build the vector of forces in wind axes system, and then transfer them to
% the frd frame. Call the vector in frd frame, FA.
FA_w = [-D; -C; -L];

alpha_e = alpha;
C_bf_to_w = [cos(alpha_e)*cos(beta) sin(beta) sin(alpha_e)*cos(beta); ...
            -cos(alpha_e)*sin(beta) cos(beta) -sin(alpha_e)*sin(beta); ...
            -sin(alpha_e) 0 cos(alpha_e)];
C_w_to_bf = C_bf_to_w';
V_w = [V_t; 0; 0];
V_bf = C_w_to_bf*V_w;

FA =C_w_to_bf*FA_w;

% Aerodynamic moments
% Compute the aerodynamic moment coefficients using the given formula.
% Then, calculate the aerodynamic moments around the aerodynamic center,
% and call it MA_ac. Then, calculate aerodynamic moments around the center
% of mass of aircraft, and call it MA.

MA_ac = [-1.4*beta; -0.59-3.1*((S_t*l_t)/(S*l))*(alpha - epsilon); (1-3.8179*alpha)*beta ]; 
MA_ac = MA_ac + [ -11 0 5; 0 -4.03*((S_t*l_t^2)/(S*l^2)) 0; 1.7 0 -11.5]*(l/V_t)*omega; 
MA_ac = MA_ac + [ -0.6 0 0.22; 0 -3.1*((S_t*l_t)/(S*l)) 0; 0 0 -0.63]*[ deltaA; deltaE; deltaR];

% calculating moments around cm
MA = MA_ac + cross(FA,cm-ac);

%% flat-Earth equations
% This section implements the flat-Earth equations. You need to implement
% the navigation equation yourself. Note that you may need to have a few
% intermediary steps before using the flat-Earth equation to simulate
% aircraft motion.

% Force equation
F = FA + FT +FG;
v_dot = F/m - cross(omega, v);

% Moment equation
M = MT + MA;
omega_dot = Jinv * (M - cross(omega, J * omega));
% M error --> h0 -->>
% Kinematical equation
H = [1, ...
    sin(phi)*tan(theta), ...
    cos(phi)*tan(theta); ...
    0, ...
    cos(phi), ...
    -sin(phi); ...
    0, ...
    sin(phi) / cos(theta), ...
    cos(phi) / cos(theta)];
Phi_dot = H* omega;

% Navigation equation
p_dot = C_frd_to_ned*v;


% Build the X_dot vector.
X_dot = [p_dot; Phi_dot; v_dot; omega_dot];
end