% tx_power_comm

clear all
clc

% Noise power spectral density in dBm/Hz
N0=4e-21;
% Bandwidth in Hz
B=20e5;

% Noise figure
F=10;
% Noise power
Pn=N0*B*F;

% Required SNR
SNR=10^1;

% Processing gain from time-bandwidth product. 
PG=1;

% Required received power
Pr=Pn*SNR/PG;

% Carrier frequency
fc=1e9; 
%fc=77e9;
c=3e8;
lambda=c/fc;


% Antennas area and antennas gain
Gt=10; Gr=1;

% Range at which to compute received power
R=linspace(1,10000,50);

% Range equation
Pt=(4*pi)^2*R.^2*Pr/(Gt*Gr*lambda^2);
Pt_dB=10*log10(Pt)+30;

semilogx(R,Pt_dB,'linewidth',2)
grid
xlabel 'Range (m)', ylabel 'Transmitted power (dBm)'
