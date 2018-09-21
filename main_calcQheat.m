
clear;

d_in = 13.0 * 10^(-3);   %m
d_out = 15.0 * 10^(-3);   %m
height = 130 * 10^(-3);  %m
lo = 2.66 * 10^3;  %kg/m^3 Al
c = 0.905 * 10^3;   %J/(kg*K)
h = 0.0;
Sectional_area = (d_out/2)^2 * pi - (d_in/2)^2 * pi;   %m^2
Surface_area = d_out * pi * height;
V = Sectional_area * height;          %m^3
m = V * lo;         %kg

q_heat = 0.0;      %W
ita_rod = 0.04;
stefan = 5.67 * 10^(-8);
F_rod = 1;
T_amb = 293;

Cd = m * c;
Cv = h * Surface_area;
R  = ita_rod * stefan * Surface_area * F_rod;
D4 = - R / Cd;
D3 = 0;
D2 = 0;
D1 = -Cv / Cd;
D0 = (q_heat / Cd) + (Cv / Cd * T_amb) + (R / Cd * T_amb^4);

timespan = [0, 250];
y0 = T_amb;
T0 = y0 - 273;
deltaT = 32;
%[t,y] = ode45(@(t,y) calc_Qheat(t,y,D1,D2), tspan, y0);    % only radiation
options  = odeset('RelTol', 1e-10, 'AbsTol', 1e-10);
[time, temperature] = ode45(@(time, temperature) calc_Qheat(time, temperature, D4, D3, D2, D1, D0), timespan, T_amb + deltaT, options);     % radiation + convection
plot(time, (temperature-273),'-o');
xlim([0,250]);
ylim([T0 - deltaT, T0 + deltaT]);   