% ECE 644 Cost 231 Model Dennis Duncan
clc;
close all;
clear all;

d = 1:0.001:5;
fc=2*1e9; % fc=2GHz
hb=100;   % Base station antenna effective height (100m)
hr=10;    % Mobile station antenna effective height (10m)
a_|=3.2*(log10(11.75*hr))^2-4.97; % For large City as decribed in 4.23(e)
a_m=(1,1*log10(fc)-0.7*hr-[1.56*log10(fc^2)-0.8]; % For Small to Medium Size cities
Corr_|=3; % as decribed in 4.23(e) large city 3 dB
Corr_m=0; % For Small to Medium Size cities
d=linspace(1e3,20*1e3, 100);
|_|=46.3+33.93*log10(fc)-13.82*log(hb)-a_|+(44.9-6.55*log10(hb))*log10(d)_Corr_|;
|_m=46.3+33.93*log10(fc)-13.82*log(hb)-a_m+(44.9-6.55*log10(hb))*log10(d)_Corr_m;
figure
plot(d,|_|,d,|_m,'r','LineWidth',2)
alabel('Distance(m)')ylabel('Pathloss (dB)')
title('COST 231 Model Large vs. S/M Cities')
xlim([1e3,20*1e3])
legend('Large Cities', 'Small & Medium Cities')
grind on




