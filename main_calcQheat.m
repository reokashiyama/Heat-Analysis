
clear;

d_in = 13.0 * 10^(-3);   %m
d_out = 15.0 * 10^(-3);   %m
height = 130 * 10^(-3);  %m
lo = 2.66 * 10^3;  %kg/m^3 Al
c = 0.905 * 10^3;   %J/(kg*K)
h = 0.0;

q_heat = 0.0;      %W
ita_rod = 0.04;
ita_rad = 0.04;
stefan = 5.67 * 10^(-8);
F_rod = 0.5;
F_rad = 1.0;
T_amb = 293;
T_space = 3;

Sectional_area = (d_out/2)^2 * pi - (d_in/2)^2 * pi;   %m^2
V = Sectional_area * height;          %m^3
m_rod = V * lo;  
Surface_rod = d_out * pi * height;
n = 10;
Surface_rad = Surface_rod * n;

Cd = m_rod * c;
Cv = h * Surface_rod;
Rrod  = ita_rod * stefan * Surface_rod * F_rod;
Rrad  = ita_rad * stefan * Surface_rad * F_rad;
D4 = -(Rrod + Rrad) / Cd;
D3 = 0;
D2 = 0;
D1 = -Cv / Cd;
D0 = (q_heat  + Cv * T_amb + Rrod * T_amb^4 + Rrad * T_space^4) / Cd;

timespan = [0, 1200];
y0 = T_amb;
T0 = y0 - 273;
deltaT = 32;
%[t,y] = ode45(@(t,y) calc_Qheat(t,y,D1,D2), tspan, y0);    % only radiation
options  = odeset('RelTol', 1e-10, 'AbsTol', 1e-10);
[time, temperature] = ode45(@(time, temperature) calc_Qheat(time, temperature, D4, D3, D2, D1, D0), timespan, T_amb, options);     % radiation + convection
plot(time, (temperature-273),'-o');
xlim([0,1200]);
ylim([T0 - deltaT, T0 + deltaT]);   