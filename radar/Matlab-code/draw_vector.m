function [x,y,z]= draw_vector(xf,yf,zf,col)
xi = 0;
yi = 0;
zi = 0;

t = 0:0.1:1;

x = xi*t+(1-t)*xf;
y = yi*t+(1-t)*yf;
z = zi*t+(1-t)*zf;
plot3(x,y,z,col)