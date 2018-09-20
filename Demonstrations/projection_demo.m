%This script generates and plots 2-dimensional Gaussian data points and then
%projects them onto the x-axis to illustrate the change in mean separation
%and variance when data is projected

clear all
clc

mu0=[5;5];
mu1=[-5;-5];
muDiff=norm(mu0-mu1);
C0=randn(2,100)+mu0;
C1=randn(2,100)+mu1;
figure
scatter(C0(1,:),C0(2,:),'red','*')
hold on
scatter(C1(1,:),C1(2,:),'blue','*')

P=[1 0];%project data points onto the x-axis
C0_proj=P*C0;
C1_proj=P*C1;
mean0_proj=mean(C0_proj);
mean1_proj=mean(C1_proj);
meanDiff_proj=norm(mean0_proj-mean1_proj);
var0_proj=var(C0_proj);
var1_proj=var(C1_proj);

figure
scatter(C0_proj,zeros(size(C0_proj)),'red','*')
hold on
scatter(C1_proj,zeros(size(C0_proj)),'blue','*')
