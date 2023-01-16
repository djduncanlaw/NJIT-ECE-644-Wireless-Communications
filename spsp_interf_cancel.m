% spsp_interf_cancel
% Illustrate interference suppression capability of spread spectrum

clear all

% Number of bits;  code length

N=64;
sir=0.1;
H=hadamard(N);
m=sign(2*(rand-0.5));

% Choose Hadamard code randomly
h=H(:,randi([2 N]));
s=h*m;

% Interference
t=1:64;
%fi=7.5/128;
%phi=pi*(rand-0.5);
%i=(1/sqrt(sir))*cos(2*pi*fi*t+j*phi);

i=(1/sqrt(sir))*sign(2*(rand(1,N)-0.5));

figure(1)
plot(t,s,t,i,'linewidth',1.5)
grid
xlabel('Time')
ylabel('Amplitude')

% Match filter
ys=xcorr(s,'biased');
yi=xcorr(s,i,'biased');
n1=1:1:2*length(t)-1;

figure(2)
plot(n1,ys,n1,yi,'linewidth',1.5)
grid
xlabel('Time')
ylabel('Amplitude')

[ysm,index]=max(abs(ys));

sir_out=(ysm)^2/(abs(yi(index)))^2

