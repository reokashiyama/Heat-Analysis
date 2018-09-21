function dy = calc_Qheat_rad_conv(t,y,C4,C3,C2,C1,C0)
dy = C4 * y^4 + C3 * y^3 + C2 * y^2 + C1 * y^1 + C0;
end
