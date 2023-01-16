% spsp_sir_gain
% Illustrate interference suppression capability of spread spectrum

clear all

% Number of bits;  code length

N=64;
sir=0.1;

C=2*randi([0,1],N,2)-0.5;

SINR=(C(:,1)'*C(:,1))^2/(C(:,1)'*C(:,2))^2
