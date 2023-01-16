clc;
clear;
close all;
[m,fs]=audioread('hw.wav'); %fs is the sampling frequency used when sampling the message -- note that m is a vector of real numbers L=length(m); %length of the message
 L=length(m); 
 NFFT=4096;
 y=fft(m,NFFT); % I applied FFT
 
 f=[-NFFT/2+1:NFFT/2]*fs/NFFT;
 
plot(f,fftshift(abs(y)));
xlabel('Frequency')
ylabel(' Mag')
grid on
% 
s=0.1; 
WI=sqrt(s)*randn(L,1); %This generates a realization of the in-phase noise sequence plot(...);
% soundsc(WI,fs);
%=================================%
WQ=sqrt(s)*randn(L,1); %This generates a realization of the quadrature noise sequence
Wz=WI+i*WQ;

 Yz=m*exp(-1*i*4/(9*pi))+Wz;
% 
Mhat=real(Yz);
soundsc(Mhat,fs);

H=(f>=20000)&(f<=-20000);
Yz_four=fftshift(fft(Yz,NFFT));
Yz_filtered=Yz_four.*H';
Yz_filtered_time=ifft(ifftshift(Yz_filtered),NFFT);
Mah1=real(Yz_filtered_time*exp(-4*i/(9*pi)));
soundsc(Mah1,fs)







