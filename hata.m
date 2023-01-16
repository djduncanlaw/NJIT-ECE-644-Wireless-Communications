% hata

clear all
clc


% Define parameters

% Wavelength in meter
fc=700;

% Antennas heights
hb=10; hm=1;

R=100:10:5000;
% Small cities correction factor 
a_sm=(1.1*log10(fc)-0.7)*hm-1.56*log10(fc^2)+0.8;

% Large cities correction factor
a_la=3.2*(log10(11.75*hm))^2-4.97;

L_urb=69.55+26.16*log10(fc)+(44.9-6.55*log10(hb))*log10(R/1000)-13.82*log10(hb);
L_urb_sm=L_urb-a_sm;
L_urb_la=L_urb-a_la;

L_sub=L_urb-2*(log10(fc/28))^2-5.4;
L_rur=L_urb-4.78*(log10(fc))^2+18.33*log10(fc)-40.94;

% Blue, red, orange 
%semilogx(R,[L_urb;L_urb_sm;L_urb_la],'linewidth',1.5);

figure
semilogx(R,[L_urb_sm;L_urb_la;L_sub;L_rur],'linewidth',1.5);
grid
xlabel('Range (m)')
ylabel('Pathloss (dB)')
title('Hata pathloss model')


figure
plot(R,[L_urb_sm;L_urb_la;L_sub;L_rur],'linewidth',1.5);
grid
xlabel('Range (m)')
ylabel('Pathloss (dB)')
title('Hata pathloss model')


