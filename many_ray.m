% many_ray
% Power received by multipath from many scatterers arranged in a circle.
% Mobile is at the center of the circle and then shifted to position along
% a radius. 

clear all
clc


% Define parameters

% Wavelength in meter
fc=700*10^6; c=3*10^8;
lambda=c/fc; 
lambda=1;
Np=100;

% Propagation constant
k0=2*pi/lambda;        

% Multipath scatterers

Np=200; r_mp=random('uniform',0,100*lambda,[Np,1]); th_mp=random('uniform',0,2*pi,[Np,1]);
%Np=2; th_mp=[0;pi/2];

% Mobile coordinates
R=0:0.01:10; Nr=length(R);

% Range base station to scatterers
R_mp=sqrt(((ones(Np,1)*R-r_mp.*cos(th_mp)*ones(1,Nr)).^2+(r_mp.*sin(th_mp).^2)));

E=exp(j*k0*R_mp);
E_mp=sum(E);


P_mp=(abs(E_mp)).^2/Np;

L_mp=10*log10(P_mp);

plot(R/lambda,L_mp,'linewidth',1.5);
grid
xlabel('Range/lambda')
ylabel('Received power (dB)')

