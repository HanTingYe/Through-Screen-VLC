function result = IsPointInTriangle(CSK_x_underscreen, CSK_y_underscreen)
G_underscreen_x=0.34;
G_underscreen_y=0.41;
B_underscreen_x=0.34;
B_underscreen_y=0.32;
R_underscreen_x=0.42;
R_underscreen_y=0.35;

PG_underscreen_x=CSK_x_underscreen-G_underscreen_x;
PG_underscreen_y=CSK_y_underscreen-G_underscreen_y;
PB_underscreen_x=CSK_x_underscreen-B_underscreen_x;
PB_underscreen_y=CSK_y_underscreen-B_underscreen_y;
PR_underscreen_x=CSK_x_underscreen-R_underscreen_x;
PR_underscreen_y=CSK_y_underscreen-R_underscreen_y;

J1=PG_underscreen_x*PB_underscreen_y-PG_underscreen_y*PB_underscreen_x;
J2=PB_underscreen_x*PR_underscreen_y-PB_underscreen_y*PR_underscreen_x;
J3=PR_underscreen_x*PG_underscreen_y-PR_underscreen_y*PG_underscreen_x;

result= J1*J2>=0 && J1*J3>=0;
end