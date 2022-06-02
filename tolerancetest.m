clc
clear variables
close all
tic

global lambda_0
folder = fileparts(mfilename('fullpath'));
addpath(genpath(folder));

% Input parameters
N=100000;
w_input=22e-6*.5;                       %input beam radius
lambda_0=343e-9;                   %center wavelength

p1s = 30:0.1:50;
focal_spots = [];
spot_sizes = [];

for i=p1s
    lens1_pos=[0,i*10^-2];                 %[X-pos of center of coupling lens, Y-pos of center of coupling lens]
    lens2_pos=[0,130e-2];              %[X-pos of center of coupling lens, Y-pos of center of coupling lens]
    det_pos=[0,145e-2];                     %[X-pos of detector, Y-pos of detector]

    f_1=40e-2;                         %focal length coupling lens
    f_2=7.506e-2;                       %focal length of fiber lens

    % Convert input parameters to code friendly units
    theta_0=lambda_0/(pi*w_input);          %diffraction angle at input
    q_in=-1/(1i*lambda_0/(pi*w_input^2));    %input complex beam parameter

    L0=sqrt((0-lens1_pos(1))^2+(0-lens1_pos(2))^2);                       %distance from input to lens
    L1=sqrt((lens2_pos(1)-lens1_pos(1))^2+(lens2_pos(2)-lens1_pos(2))^2);   %distance from lens to slit
    L2=sqrt((det_pos(1)-lens2_pos(1))^2  +(det_pos(2)-lens2_pos(2))^2);     %distance from CM2 to detector

    % Propagation of beam
    [curvature0, radius0, q_var, Z0]=propagation(q_in,N,L0);        %propagation from laser to lens1
    q_var=lens(f_1,q_var);                                          %propagation through lens1
    [curvature1, radius1, q_var, Z1]=propagation(q_var,N,L1);       %propagation from lens1 to lens2
    q_var=lens(f_2,q_var);                                          %propagation through lens2
    [curvature2, radius2, q_var, Z2]=propagation(q_var,N,L2);       %propagation from lens2 to detector

    Z_tot=[Z0 Z0(end)+Z1 Z0(end)+Z1(end)+Z2];
    radius_tot=[radius0 radius1 radius2];
    curvature_tot=[curvature0 curvature1 curvature2];
    
    [m,n]=min(radius_tot);
    spot_sizes(end+1) = m*2e6;
    focal_spots(end+1) = Z_tot(n)*1e2 - lens2_pos(2)*1e2;
end

% Display output
figure
hold on
% scatter(p1s,spot_sizes,40,focal_spots,'filled')
% plot(50:0.01:70, spot_sizes, "LineWidth",1.5,'color','#008000');
plot(p1s, focal_spots, 'k');
hold off

% ax = gca;
% ax.FontSize = 12;
set(gca,'fontsize',12);
set(gca,'fontname','helvetica');
title('3ω focal plane with f = 40 cm lens','fontsize',14)
xlabel('Position of lens (cm)','fontsize',12)
% ylabel('1/e^2 Beam diameter (um)','fontsize',12)
ylabel('Focal plane (mm)','fontsize',12)
% h = colorbar;
% ylabel(h, 'Focal plane (mm)','fontsize',12)
grid on

toc
