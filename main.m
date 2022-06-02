clc
clear variables
close all
tic

global lambda_0
folder = fileparts(mfilename('fullpath'));
addpath(genpath(folder));

%% Input parameters
N=1000;
w_input=32e-6;                       %input beam radius
lambda_0=1030e-9;                   %center wavelength

lens1_pos=[0,29e-2];                 %[X-pos of center of coupling lens, Y-pos of center of coupling lens]
lens2_pos=[0,130.5e-2];              %[X-pos of center of coupling lens, Y-pos of center of coupling lens]
det_pos=[0,138.214e-2];                     %[X-pos of detector, Y-pos of detector]

f_1=30e-2;                         %focal length coupling lens
f_2=7.41e-2;                       %focal length of fiber lens

%% Convert input parameters to code friendly units                 
theta_0=lambda_0/(pi*w_input);          %diffraction angle at input
q_in=1/(1i*lambda_0/(pi*w_input^2));    %input complex beam parameter

L0=sqrt((0-lens1_pos(1))^2+(0-lens1_pos(2))^2);                       %distance from input to lens
L1=sqrt((lens2_pos(1)-lens1_pos(1))^2+(lens2_pos(2)-lens1_pos(2))^2);   %distance from lens to slit
L2=sqrt((det_pos(1)-lens2_pos(1))^2  +(det_pos(2)-lens2_pos(2))^2);     %distance from CM2 to detector
%% Propagation of beam
[curvature0, radius0, q_var, Z0]=propagation(q_in,N,L0);        %propagation from laser to lens1
q_var=lens(f_1,q_var);                                          %propagation through lens1
[curvature1, radius1, q_var, Z1]=propagation(q_var,N,L1);       %propagation from lens1 to lens2
q_var=lens(f_2,q_var);                                          %propagation through lens2
[curvature5, radius2, q_var, Z2]=propagation(q_var,N,L2);       %propagation from lens2 to detector

Z_tot=[Z0 Z0(end)+Z1 Z0(end)+Z1(end)+Z2];
radius_tot=[radius0 radius1 radius2];

%% Ray tracing of beam
% spectrometer_layout(lens_pos,slit_pos,CM1_pos,G_pos,CM2_pos,det_pos);
% ray_trace_spectro(w_input,lens_pos,slit_pos,CM1_pos,G_pos,CM2_pos,radius0,radius1,lambda_0,d)


%% Display output
figure
hold on
plot(Z_tot*1e2, radius_tot*1e3, "LineWidth",1.5,'color','#008000');
xline(L0*1e2, '-', 'Lens 1', "LineWidth",1.5,'FontSize',12,'LabelVerticalAlignment','middle');
xline((L0+L1)*1e2, '-', 'Lens 2', "LineWidth",1.5,'FontSize',12,'LabelVerticalAlignment','middle');
hold off

ax = gca;
ax.FontSize = 12;
title('Green beam size','fontsize',14)
xlabel('Propagation distance (cm)','fontsize',12)
xlim([0 145])
ylabel('1/e^2 Beam radius (mm)','fontsize',12)
grid on

autoArrangeFigures()

disp('Function main...... OK')
toc