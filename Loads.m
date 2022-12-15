function[RJ85.init, RJ85.load] = Loads(x, vis)

global data 
%Design Vector Entries:
%x = [CST,c1,lambda1,lambda2,theta2,theta3,LEsw,b,Wwing,Wfuel,L/DcrAC]
%x = [1-24,25, 26      27      28     29    30  31  32    33     34]
xref = [CST; 3.94; 0.75; 0.475; 100; 100; 17.82; 26.21;  3956.147 ; 10023; 16];
x = x.*xref

%%_Q3D starter code_%%
% Wing planform geometry 
%               x  y  z  chord(m)  twist angle (deg) 
AC.Wing.Geom = [data.x1 data.y1 data.z1 data.c1 0;
                data.x2 data.y2 data.z2 data.c2 data.theta2;
                data.x3 data.y3 data.z3 data.c3 data.theta3];

% Wing incidence angle (degree)
AC.Wing.inc  = 0;   
            
% Airfoil coefficients input matrix
%                    | ->     upper curve coeff.                <-|   | ->       lower curve coeff.       <-| 
AC.Wing.Airfoils   = [x(1) x(2) x(3) x(4) x(5) x(6) x(7) x(8) x(9) x(10) x(11) x(12);
                      x(13) x(14) x(15) x(16) x(17) x(18) x(19) x(20) x(21) x(22) x(23) x(24)];

AC.Wing.eta = [0; data.y2/(x(31)/2); 1];  % Spanwise location of the airfoil sections

% Viscous vs inviscid
AC.Visc  = vis;              % 0 for inviscid and 1 for viscous analysis
AC.Aero.MaxIterIndex = 150;  %Maximum number of Iteration for the
                             %convergence of viscous calculation
                               
S = 2*((x(25) + x(25)*x(26)/2)*data.y2 + (((x(25)*x(26) + x(25)*x(26)*x(27))/2)*x(31)/2 - data.y2));
MAC = S/x(31);               %Mean aerodynamic chord [m]

% Flight Condition
MTOW          = data.WAW + x(32) + x(33);         %[kg]
AC.Aero.V     = 0.73*data.a;                           % flight speed (m/s)
AC.Aero.rho   = data.rho;                         % air density  (kg/m3)
AC.Aero.alt   = data.hcr*0.3048;                           % flight altitude (m)
AC.Aero.Re    = AC.Aero.rho*AC.Aero.V*MAC/(data.dynvis);        % reynolds number (bqased on mean aerodynamic chord)
AC.Aero.M     = AC.Aero.V/data.a;                     % flight Mach number
n_max = 2.5;
AC.Aero.CL    = (n_max*MTOW*9.81)/(0.5*AC.Aero.rho*AC.Aero.V^2*S);          % lift coefficient - comment this line to run the code for given alpha%
%AC.Aero.Alpha = 2;             % angle of attack -  comment this line to run the code for given cl 

%% 
tic
Res = Q3D_solver(AC);
toc

%%_Writing results of Q3D in to a .load txt file_%%
Res.Wing.Yst = (Res.Wing.Yst')/(x(31)/2);
Lift_Load = (Res.Wing.ccl*0.5*AC.Aero.rho*AC.Aero.V^2*(0.066921*x(31)/2))';
Moment_Load = ((0.066921*x(31)/2)*Res.Wing.chord.*Res.Wing.chord.*Res.Wing.cm_c4*0.5*AC.Aero.rho*AC.Aero.V^2)';
array = [Res.Wing.Yst; Lift_Load; Moment_Load];

fid = fopen('RJ85.load','wt');
fprintf(fid, '%f %f %f \n', 0, Lift_Load(1), Moment_Load(1) );
fprintf(fid, '%f %f %f \n', array);
fprintf(fid, '%f %f %f \n', 1.0, 0, 0);
fclose(fid);

%%%_Make a txt file of the airfoil co-ordinates using the CST coefficients_%%%
CST_root    = [ x(1) x(2) x(3) x(4) x(5) x(6) x(7) x(8) x(9) x(10) x(11) x(12) ];
CST_tip     = [ x(13) x(14) x(15) x(16) x(17) x(18) x(19) x(20) x(21) x(22) x(23) x(24) ];

RootUp = transpose(CST_root(1:6));
RootLow = transpose(CST_root(7:12));
TipUp = CST_tip(1:6);
TipLow = CST_tip(7:12);

xairfoil = transpose(linspace(0,1,101));

[Xtu_root, Xtl_root] = D_airfoil2(RootUp, RootLow, xairfoil);
[Xtu_tip, Xtl_tip] = D_airfoil2(TipUp, TipLow, xairfoil);

fid = fopen('RootAirfoil.txt','wt');
fprintf(fid, '%f %f \n', Xtu_root');
fprintf(fid, '%f %f \n', Xtl_root');
fclose(fid);

fid = fopen('TipAirfoil.txt','wt');
fprintf(fid, '%f %f \n', Xtu_tip');
fprintf(fid, '%f %f \n', Xtl_tip');
fclose(fid);

%%%_Routine to write the input file for the EMWET procedure_%%%
namefile    =    char('RJ85.init');
MTOW        =    x(32) + x(33) + data.WAW ;         %[kg]
MZF         =    35834;            %[kg]
nz_max      =    n_max;   
span        =    x(31);            %[m]
root_chord  =    x(25);            %[m]
taper1      =    x(26);            %[-]
taper2      =    x(27);            %[-]
Airfoil_root=    'RootAirfoil.txt';
Airfoil_tip =    'TipAirfoil.txt';
wing_surf   =    S;

x2 = x(25) - x(25)*x(26) + data.y2*sind(data.TEsw);  %%%THIS IS IN DEGREES SHOULD BE IN X AS WELL 
x3 = x2 + (b/2 - y2)*sind(x(30)); %%%THIS IS IN DEGREES SHOULD BE IN X AS WELL
y3 = x(30)/2;
z3 = y3*sind(-5);

%%%_Print statements for input file for the EMWET procedure_%%%

fid = fopen('RJ85.init','wt');
fprintf(fid, '%g %g \n', MTOW*9.81, MZF);
fprintf(fid, '%g \n', nz_max);

fprintf(fid, '%g %g %g %g \n', wing_surf, span, data.section_num, data.airfoil_num);

fprintf(fid, '0 %s \n', Airfoil_root);
fprintf(fid, '1 %s \n', Airfoil_tip);

fprintf(fid, '%g %g %g %g %g %g \n', root_chord, data.x1, data.y1, data.z1, data.front_spar, data.rear_spar);
fprintf(fid, '%g %g %g %g %g %g \n', root_chord*taper1, x2, data.y2, data.z2, data.front_spar, data.rear_spar);
fprintf(fid, '%g %g %g %g %g %g \n', root_chord*taper1*taper2, x3, y3, z3, data.front_spar, data.rear_spar);

fprintf(fid, '%g %g \n', data.ftank_start, data.ftank_end);

fprintf(fid, '%g \n', data.eng_num);
fprintf(fid, '%g  %g \n', data.eng_ypos1, data,eng_mass);
fprintf(fid, '%g  %g \n', data.eng_ypos2, data.eng_mass);

fprintf(fid, '%g %g %g %g \n', data.E_al, data.rho_al, data.Ft_al, data.Fc_al);
fprintf(fid, '%g %g %g %g \n', data.E_al, data.rho_al, data.Ft_al, data.Fc_al);
fprintf(fid, '%g %g %g %g \n', data.E_al, data.rho_al, data.Ft_al, data.Fc_al);
fprintf(fid, '%g %g %g %g \n', data.E_al, data.rho_al, data.Ft_al, data.Fc_al);

fprintf(fid,'%g %g \n', data.eff_factor, data.pitch_rib);
fprintf(fid, '%g \n', vis);
fclose(fid);