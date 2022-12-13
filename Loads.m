function[RJ85.init, RJ85.load] = Loads(x, vis)

global data 

%Design Vector Entries:
%x = [CST,c1,lambda1,lambda2,theta2,theta3,LEsw,b,Wwing,Wfuel,L/DcrAC]
%x = [1-24,25, 26      27      28     29    30  31  32    33     34]

also giong to have to run Q3D here to get the L and M distributions

then i can write my loads files 

to get my init file i have to do the code being written below 

cst parameters -> make txt file  

CST_up_root    = x[1], x[2], x[3], x[4], x[5], x[6];
CST_lower_root = x[7], x[8], x[9], x[10], x[11], x[12];
CST_up_tip     = x[13], x[14], x[15], x[16], x[17], x[18];
CST_lower_tip  = x[19], x[20], x[21], x[22], x[23], x[24];

[Xtu_root, Xtl_root] = D_airfoil2(CST_up_root, CST_lower_root, [01]');
[Xtu_tip, Xtl_tip] = D_airfoil2(CST_up_tip, CST_lower_tip, [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]');

fid = fopen('TipAirfoil.txt','wt');
fprintf(fid, '%f %f \n', [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]' );


%%%_Routine to write the input file for the EMWET procedure_%%%
namefile    =    char('RJ85.init');
MTOW        =    x[32] + x[33] + data.WAW ;         %[kg]
MZF         =    35834;         %[kg]
nz_max      =    n_max;   
span        =    x[31];            %[m]
root_chord  =    x[25];            %[m]
taper1      =    x[26];
taper2      =    x[27];
Airfoil_root=    'RootAirfoil';
Airfoil_tip =    'TipAirfoil';
wing_surf   =    ((x[25] + x[25]*x[26])/2)*data.y2 + ((x[25]*x[26] + x[25]*x[26]*x[27])/2)*(x[31]/2 - data.y2))*2 ;

fid = fopen('RJ85.init','wt');
fprintf(fid, '%g %g \n', MTOW*9.81, MZF);
fprintf(fid, '%g \n',nz_max);

fprintf(fid, '%g %g %g %g \n', wing_surf, span, data.section_num, data.airfoil_num);

fprintf(fid, '0 %s \n', Airfoil_root);
fprintf(fid, '1 %s \n', Airfoil_tip);

fprintf(fid, '%g %g %g %g %g %g \n', root_chord, data.x1, data.y1, data.z1, data.front_spar, data.rear_spar);
fprintf(fid, '%g %g %g %g %g %g \n', root_chord*taper1, x2, y2, z2, data.front_spar, data.rear_spar);
fprintf(fid, '%g %g %g %g %g %g \n', root_chord*taper1*taper2, x3, y3, z3, data.front_spar, data.rear_spar);

fprintf(fid, '%g %g \n', data.ftank_start, data.ftank_end);

fprintf(fid, '%g \n', data.eng_num);
fprintf(fid, '%g  %g \n', data.eng_ypos1, data,eng_mass);
fprintf(fid, '%g  %g \n', data.eng_ypos2, data.eng_mass);

fprintf(fid, '%g %g %g %g \n', data.E_al, data.rho_al, data.Ft_al, data.Fc_al);
fprintf(fid, '%g %g %g %g \n', data.E_al, data.rho_al, data.Ft_al, data.Fc_al);
fprintf(fid, '%g %g %g %g \n', data.E_al, data.rho_al, data.Ft_al, data.Fc_al);
fprintf(fid, '%g %g %g %g \n', data.E_al, data.rho_al, data.Ft_al, data.Fc_al);

fprintf(fid,'%g %g \n', data.eff_factor, data.pitch_rib)
fprintf(fid, '%g \n', vis)
fclose(fid)