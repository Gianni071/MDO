<<<<<<< HEAD
clc
clear all
close all

%% Create global data (UPDATE IF ANY CONSTANTS CHANGE)
global data

%Fuselage drag
data.Dfus = 12307.5387; %[N]

%Reference planform values
data.x1 = 0; %[m]
data.y1 = 0; %[m]
data.z1 = 0; %[m]
data.y2 = 5.25; %[m]
data.z2 = -0.458; %[m]
data.TEsw = 6.15; %[deg]
data.dihedral = -5; %[deg]
data.Sref = 75.246; %[m^2]
data.Vaux = 1.174; %[m^3]

%Change this!
data.WAW = 26855.57; %[kg] ZFW - Wing weight 
data.WSref = 560.61; %[kg/m^2]
data.MTOWref = 42184; %[kg]

%Flight Conditions and Atmospheric Conditions (Atmospheric conditions: https://www.digitaldutch.com/atmoscalc/)
data.Vcr = 356; %[kts]
data.hcr = 29000; %[ft]
data.rho = 0.475448; %[kg/m^3]
data.a = 304.484; %[m/s]
data.dynvis = 0.0000151075; %[Pa s]

%Properties of Aluminium 
data.E_al        =    70E9;         %N/m2
data.rho_al      =    2800;         %kg/m3
data.Ft_al       =    295E6;        %N/m2
data.Fc_al       =    295E6;        %N/m2

%EMWET Input Constants 
data.section_num =    3;       %[number of sections]
data.airfoil_num =    2;       %[number of airfoils]
data.eng_mass    =    606;     %[kg]
data.pitch_rib   =    0.5;     %[m]
data.eff_factor  =    0.96;    %Depend on the stringer type
data.front_spar  =    0.16;      %[-]
data.rear_spar   =    0.6;      %[-]
data.ftank_start =    0.1;     %[y/y3]
data.ftank_end   =    0.85;    %[y/y3]
data.eng_num     =    2;       %[-]
data.eng_ypos1   =    0.315;   %[y/y3]
data.eng_ypos2   =    0.50;    %[y/y3]

%Get initial CST coefficients
CSTroot = readmatrix('RootRefCST.txt');
CSTtip = readmatrix('TipRefCST.txt');
CST = [CSTroot; CSTtip];

xref = [CST; 4.128; 0.75; 0.522; 100; 100; 17.82; 26.34;  4774.7 ; 10553.734; 15];
data.xref = xref;
x0 = xref./xref;

%% Load Iteration Data
matobj = matfile("run6.mat");

outputfcn = matobj.outputFcn_global_data;

%Create design vector array
n = length(outputfcn);
xarray = [];

for i= 2:n
    out = outputfcn(1,i);
    x = out.x;  
    xarray = cat(2,xarray,x);
end

%Create constraint and fval arrays
fvalarray = [];
carray = [];
ceqarray = [];

%Add values per iteration

for i= 1:n-1
    x = xarray(:,i);
    [fval,c,ceq] = IterationCheckFunction(x);
    fvalarray = cat(2,fvalarray,fval);
    carray = cat(2,carray,c);
    ceqarray = cat(2,ceqarray,ceq);
end


c1array = carray(1,:);
c2array = carray(2,:);

ceq1array = ceqarray(1,:);
ceq2array = ceqarray(2,:);
ceq3array = ceqarray(3,:);


=======
clc
clear all
close all

%% Create global data (UPDATE IF ANY CONSTANTS CHANGE)
global data

%Fuselage drag
data.Dfus = 12307.5387; %[N]

%Reference planform values
data.x1 = 0; %[m]
data.y1 = 0; %[m]
data.z1 = 0; %[m]
data.y2 = 5.25; %[m]
data.z2 = -0.458; %[m]
data.TEsw = 6.15; %[deg]
data.dihedral = -5; %[deg]
data.Sref = 75.246; %[m^2]
data.Vaux = 1.174; %[m^3]

%Change this!
data.WAW = 26855.57; %[kg] ZFW - Wing weight 
data.WSref = 560.61; %[kg/m^2]
data.MTOWref = 42184; %[kg]

%Flight Conditions and Atmospheric Conditions (Atmospheric conditions: https://www.digitaldutch.com/atmoscalc/)
data.Vcr = 356; %[kts]
data.hcr = 29000; %[ft]
data.rho = 0.475448; %[kg/m^3]
data.a = 304.484; %[m/s]
data.dynvis = 0.0000151075; %[Pa s]

%Properties of Aluminium 
data.E_al        =    70E9;         %N/m2
data.rho_al      =    2800;         %kg/m3
data.Ft_al       =    295E6;        %N/m2
data.Fc_al       =    295E6;        %N/m2

%EMWET Input Constants 
data.section_num =    3;       %[number of sections]
data.airfoil_num =    2;       %[number of airfoils]
data.eng_mass    =    606;     %[kg]
data.pitch_rib   =    0.5;     %[m]
data.eff_factor  =    0.96;    %Depend on the stringer type
data.front_spar  =    0.16;      %[-]
data.rear_spar   =    0.6;      %[-]
data.ftank_start =    0.1;     %[y/y3]
data.ftank_end   =    0.85;    %[y/y3]
data.eng_num     =    2;       %[-]
data.eng_ypos1   =    0.315;   %[y/y3]
data.eng_ypos2   =    0.50;    %[y/y3]

%Get initial CST coefficients
CSTroot = readmatrix('RootRefCST.txt');
CSTtip = readmatrix('TipRefCST.txt');
CST = [CSTroot; CSTtip];

xref = [CST; 4.128; 0.75; 0.522; 100; 100; 17.82; 26.34;  4774.7 ; 10553.734; 15];
data.xref = xref;
x0 = xref./xref;

%% Load Iteration Data
matobj = matfile("iterationdata.mat");

outputfcn = matobj.outputFcn_global_data;

%Create design vector array
n = length(outputfcn);
xarray = [];

for i= 2:n
    out = outputfcn(1,i);
    x = out.x;  
    xarray = cat(2,xarray,x);
end

%Create constraint and fval arrays
fvalarray = [];
carray = [];
ceqarray = [];

%Add values per iteration

for i= 1:n-1
    x = xarray(:,i);
    [fval,c,ceq] = IterationCheckFunction(x);
    fvalarray = cat(2,fvalarray,fval);
    carray = cat(2,carray,c);
    ceqarray = cat(2,ceqarray,ceq);
end


c1array = carray(1,:);
c2array = carray(2,:);

ceq1array = ceqarray(1,:);
ceq2array = ceqarray(2,:);
ceq3array = ceqarray(3,:);


>>>>>>> 8d9fa3701bcf12a31b750160a84cba6585c351f0
