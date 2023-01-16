
% sum_rv
% Show that sum of random variables of a distribution that is not normal
% becomes normal. 

clf
clear

% Uniform distribution
s1=rand(1000,20);
s2=sum(s1,2)/20;

h1=histogram(s1(:,1));
hold('on')
h2=histogram(s2);


