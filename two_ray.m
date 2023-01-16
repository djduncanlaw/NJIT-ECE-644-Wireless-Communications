% two_ray_pathloss

clear all
clc


% Define parameters

% Wavelength in meter
fc=700*10^6; c=3*10^8;
lambda=c/fc; 

% Propagation constant
k0=2*pi/lambda;        

R=10:10:10000;
%R=200;
hb=10; hm=2;

R_los=sqrt(R.^2+(hb-hm)^2);
R_nlos=sqrt(R.^2+(hb+hm)^2);

E_los=(1./R_los).*exp(j*k0*R_los);
E_nlos=(1./R_nlos).*exp(j*k0*R_nlos);
E_2ray=E_los-E_nlos;

P_los=(abs(E_los)).^2;
P_2ray=(abs(E_2ray)).^2;

% Pathloss based on field equations
L_los=-10*log10(P_los);
L_2ray=-10*log10(P_2ray);

% Pathloss based on closed form expressions
L_los_for=20*log10(4*pi*R/lambda);
L_2ray_for=20*log10(R.^2/(hb*hm));

semilogx(R,L_los,R,L_2ray,'linewidth',1.5);
grid
xlabel('Range (m)')
ylabel('Pathloss (dB)')

figure

semilogx(R,L_los_for,R,L_2ray_for,'linewidth',1.5);
grid
xlabel('Range (m)')
ylabel('Pathloss (dB)')



%xlim([-0.5,0.5])
%ylim([70,135])



