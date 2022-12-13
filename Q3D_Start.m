%% Aerodynamic solver setting
clear all
close all
clc

b = 26.21;

lambda1 = 0.750; 
lambda2 = 0.475; 

delta_TE_in = 6.15*pi/180;
delta_LE_out = 17.82*pi/180;

c1 = 3.94;
c2 = lambda1*c1; 
c3 = lambda2*c2;

x1 = 0;
y1 = 0;
z1 = 0;

y2 = 5.25;
x2 = c1 - c2 + y2*sin(delta_TE_in);
z2 = -0.458;

x3 = x2 + (b/2 - y2)*sin(delta_LE_out);
y3 = b/2;
z3 = y3*sin(-5*pi/180);

S = 2*(y2*(c1 + c2)/2 + (y3-y2)*(c2 + c3)/2);

% Wing planform geometry 
%                x    y     z   chord(m)    twist angle (deg) 
AC.Wing.Geom = [x1 y1 z1 c1 0;
                x2 y2 z2 c2 0
                x3 y3 z3 c3 0];

% Wing incidence angle (degree)
AC.Wing.inc  = 0;   
            
% Airfoil coefficients input matrix
%                    | ->     upper curve coeff.                <-|   | ->       lower curve coeff.       <-| 
AC.Wing.Airfoils   = [0.1621 0.2506 -0.05801 0.4901 0.01004 0.7148 -0.2468 -0.1792 -0.05085 -0.5233 0.08111 0.3562;
                      0.09264 0.1434 -0.03347 0.2805 0.005353 0.4087 -0.1410 -0.1025 -0.02887 -0.2992 0.04652 0.2034];

AC.Wing.eta = [0; y2/(b/2); 1];  % Spanwise location of the airfoil sections

% Viscous vs inviscid
AC.Visc  = 0;              % 0 for inviscid and 1 for viscous analysis
AC.Aero.MaxIterIndex = 150;    %Maximum number of Iteration for the
                                %convergence of viscous calculation
                               
a = 304; 
MAC = S/b;

% Flight Condition
MTOW          = 42184;         %[kg]
AC.Aero.V     = 0.73*304;            % flight speed (m/s)
AC.Aero.rho   = 0.4663;         % air density  (kg/m3)
AC.Aero.alt   = 8839.2;             % flight altitude (m)
AC.Aero.Re    = AC.Aero.rho*AC.Aero.V*MAC/(0.00001504);        % reynolds number (bqased on mean aerodynamic chord)
AC.Aero.M     = AC.Aero.V/a ;           % flight Mach number 
n_max = 2.5
AC.Aero.CL    = (n_max*MTOW*9.81)/(0.5*AC.Aero.rho*AC.Aero.V^2*S)          % lift coefficient - comment this line to run the code for given alpha%
%AC.Aero.Alpha = 2;             % angle of attack -  comment this line to run the code for given cl 

%% 
tic

Res = Q3D_solver(AC);

toc

%scatter([x1, x2, x3, x1+c1, x2+c2, x3+c3], [y1, y2, y3, y1, y2, y3])
%axis([0,20,0,20])
scatter(Res.Wing.Yst, Res.Wing.ccl)

Res.Wing.Yst = (Res.Wing.Yst')/(b/2);
Lift_Load = (Res.Wing.ccl*0.5*AC.Aero.rho*AC.Aero.V^2*(0.066921*b/2))';
Moment_Load = ((0.066921*b/2)*Res.Wing.chord.*Res.Wing.chord.*Res.Wing.cm_c4*0.5*AC.Aero.rho*AC.Aero.V^2)';
array = [Res.Wing.Yst;
         Lift_Load;
         Moment_Load]

fid = fopen('RJ85.load','wt');

fprintf(fid, '%f %f %f \n', 0, 47214.015443, -47735.241443 );
fprintf(fid, '%f %f %f \n', array);
fprintf(fid, '%f %f %f \n', 1.0, 0, 0);

fclose(fid)

%%%_____Routine to write the input file for the EMWET procedure________% %%

namefile    =    char('RJ85.init');
MTOW        =    42184;         %[kg]
MZF         =    35834;         %[kg]
nz_max      =    n_max;   
span        =    b;            %[m]
root_chord  =    c1;           %[m]
taper1      =    lambda1;
taper2      =    lambda2;
spar_front  =    0.2;
spar_rear   =    0.6;
ftank_start =    0.1;
ftank_end   =    0.85;
eng_num     =    2;
eng_ypos1   =    0.31;
eng_ypos2   =    0.51;

eng_mass    =    606;         %kg
E_al        =    70E9;       %N/m2
rho_al      =    2800;         %kg/m3
Ft_al       =    295E6;        %N/m2
Fc_al       =    295E6;        %N/m2
pitch_rib   =    0.5;          %[m]
eff_factor  =    0.96;             %Depend on the stringer type
Airfoil_root=    'RootAirfoil';
Airfoil_tip =    'TipAirfoil';
section_num =    3;
airfoil_num =    2;
wing_surf   =    S;

fid = fopen('RJ85.init','wt');
fprintf(fid, '%g %g \n', MTOW, MZF);
fprintf(fid, '%g \n',nz_max);

fprintf(fid, '%g %g %g %g \n', wing_surf, span, section_num, airfoil_num);

fprintf(fid, '0 %s \n', Airfoil_root);
fprintf(fid, '1 %s \n', Airfoil_tip);

fprintf(fid, '%g %g %g %g %g %g \n', root_chord, x1, y1, z1, spar_front, spar_rear);
fprintf(fid, '%g %g %g %g %g %g \n', root_chord*taper1, x2, y2, z2, spar_front, spar_rear);
fprintf(fid, '%g %g %g %g %g %g \n', root_chord*taper1*taper2, x3, y3, z3, spar_front, spar_rear);

fprintf(fid, '%g %g \n',ftank_start, ftank_end);

fprintf(fid, '%g \n', eng_num);
fprintf(fid, '%g  %g \n', eng_ypos1, eng_mass);
fprintf(fid, '%g  %g \n', eng_ypos2, eng_mass);

fprintf(fid, '%g %g %g %g \n',E_al,rho_al,Ft_al,Fc_al);
fprintf(fid, '%g %g %g %g \n',E_al,rho_al,Ft_al,Fc_al);
fprintf(fid, '%g %g %g %g \n',E_al,rho_al,Ft_al,Fc_al);
fprintf(fid, '%g %g %g %g \n',E_al,rho_al,Ft_al,Fc_al);

fprintf(fid,'%g %g \n',eff_factor,pitch_rib)
fprintf(fid,'1 \n')
fclose(fid)