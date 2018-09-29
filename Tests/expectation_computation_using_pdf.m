%This script computes E[R'*(R*Sigma*R')*R] with respect to the pdf of R
%given by f(R)=(1/sqrt(2*pi))*exp(-0.5*trace(RR')) (when R's entries are standard normal iid)
clear all
clc

k=2;p=4;
syms r11 r12 r13 r14 r21 r22 r23 r24 real
syms pi
R=[r11 r12 r13 r14;r21 r22 r23 r24];
Sigma=eye(4);
pdf=(1/sqrt(2*pi))^(k*p)*exp(-0.5*trace(R*R'));
integrand=R'*(R*Sigma*R')*R*pdf;
expectation=int(int(int(int(int(int(int(int(integrand,r11,-Inf,Inf),r12,-Inf,Inf),r13,-Inf,Inf),r14,-Inf,Inf),r21,-Inf,Inf),r22,-Inf,Inf),r23,-Inf,Inf),r24,-Inf,Inf)


% k=2;p=2;
% syms r11 r12 r21 r22 real
% syms s11 s12 s22 real
% syms pi
% R=[r11 r12;r21 r22];
% % Sigma=[s11 s12;s12 s22];
% Sigma=eye(2);
% pdf=(1/sqrt(2*pi))^(k*p)*exp(-0.5*trace(R*R'));
% integrand=R'*(R*Sigma*R')*R*pdf;
% t1=int(integrand,r11,-Inf,Inf);
% t2=int(t1,r12,-Inf,Inf);
% t3=int(t2,r21,-Inf,Inf);
% expectation=int(t3,r22,-Inf,Inf);


% k=1;p=2;
% syms r11 r12 real
% syms s11 s12 s22 real
% syms pi
% R=[r11 r12];
% %Sigma=[s11 s12;s12 s22];
% Sigma=eye(2);
% pdf=(1/sqrt(2*pi))^(k*p)*exp(-0.5*trace(R*R'));
% integrand=R'*(R*Sigma*R')*R*pdf;
% t1=int(integrand,r11,-Inf,Inf);
% expectation=int(t1,r12,-Inf,Inf);


