% rayleigh_demo
clear all;
close all

% Number of runs; number of multipath components
N=10000;
K=100; 

% Amplitude of multipath components are uniform random
% Phase of multipath components are uniform random
a=rand(N,K);
phi=2*pi*rand(N,K);

% Quadrature components. Notation from class notes. 
X=sum(a.*cos(phi));
Y=sum(a.*sin(phi));
R=sqrt(X.^2+Y.^2);

% Use Distribution Fitting app to demonstrate R is Rayleigh distributed

% Plot below demonstrates different amplitude and phases. 

for t=1:1:50
    sum=0; %initialization for s
    for i=1:N
        sum=sum+a(i)*cos(2*pi*t/10+phi(i));
    end
    s(t)=sum;  %generate signal s(t)
end
t=1:50;
plot(t,s,'linewidth', 1.5);
grid
ylim([-60,60])