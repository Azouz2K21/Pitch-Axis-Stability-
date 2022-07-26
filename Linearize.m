function [E,A_P,B_P] = Linearize(MY_FUN,XDOTo, Xo, Uo, DXDOT, DX, DU)

%Obtain number of states and controls
n = length(XDOTo);
m = length(Uo);

%----------------------------Calculate E Matrix----------------------------
%Initialize E matrix
E = zeros(n,n);

%Fill in each element of the matrix individually
for i = 1:n
    for j = 1:n
        %Obtain the magnitude of the perturbation to use.
        dxdot = DXDOT(i,j);

        %Define perturbation vector. The current column determines which
        %element of xdot we are perturbing.
        xdot_plus = XDOTo;
        xdot_minus = XDOTo;

        xdot_plus(j) = xdot_plus(j) + dxdot;
        xdot_minus(j) = xdot_minus(j) - dxdot;

        %Calculate F(row) (xdot_plus, xo, uo)
        F = feval(MY_FUN,xdot_plus,Xo,Uo);
        F_plus_keep = F(i);

        %Calcualte F(row) (xdot_minus, xo, uo)
        F = feval(MY_FUN,xdot_minus,Xo,Uo);
        F_minus_keep = F(i);

        %Calculate E(row,col)
        E(i,j) = (F_plus_keep - F_minus_keep) / (2*dxdot);
    end
end


%---------------------------Calculate A_P Matrix---------------------------
%Initialize E matrix
A_P = zeros(n,n);

%Fill in each element of the matrix individually
for i = 1:n
    for j = 1:n
        %Obtain the magnitude of the perturbation to use.
        dx = DX(i,j);

        %Define perturbation vector. The current column determines which
        %element of xdot we are perturbing.
        x_plus = Xo;
        x_minus = Xo;

        x_plus(j) = x_plus(j) + dx;
        x_minus(j) = x_minus(j) - dx;

        %Calculate F(row) (xdot_plus, xo, uo)
        F = feval(MY_FUN,XDOTo,x_plus,Uo);
        F_plus_keep = F(i);

        %Calcualte F(row) (xdot_minus, xo, uo)
        F = feval(MY_FUN,XDOTo,x_minus,Uo);
        F_minus_keep = F(i);

        %Calculate E(row,col)
        A_P(i,j) = (F_plus_keep - F_minus_keep) / (2*dx);
    end
end


%---------------------------Calculate B_P Matrix---------------------------
%Initialize E matrix
B_P = zeros(n,m);

%Fill in each element of the matrix individually
for i = 1:n
    for j = 1:m
        %Obtain the magnitude of the perturbation to use.
        du = DU(i,j);

        %Define perturbation vector. The current column determines which
        %element of xdot we are perturbing.
        u_plus = Uo;
        u_minus = Uo;

        u_plus(j) = u_plus(j) + du;
        u_minus(j) = u_minus(j) - du;

        %Calculate F(row) (xdot_plus, xo, uo)
        F = feval(MY_FUN,XDOTo,Xo,u_plus);
        F_plus_keep = F(i);

        %Calcualte F(row) (xdot_minus, xo, uo)
        F = feval(MY_FUN,XDOTo,Xo,u_minus);
        F_minus_keep = F(i);

        %Calculate E(row,col)
        B_P(i,j) = (F_plus_keep - F_minus_keep) / (2*du);
    end
end

