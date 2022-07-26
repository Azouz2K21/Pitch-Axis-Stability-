
numerator=[1.151 0.1774];
denominator=[1 0.739 0.921 0];
sys = tf(numerator,denominator);
[A,B,C,D] = tf2ss(numerator,denominator );

Q = 0.001*eye(3);
R = eye(1);
[K,S,e]=lqr(A,B,Q,R);