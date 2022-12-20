% Source 1: https://booksite.elsevier.com/9780340741528/appendices/data-a/table-8/table.htm

global initial inputs

% Initial values
initial.c_r = 4.8;          % [m]
initial.tr_i = 0.6;         % [-]
initial.tr_o = 0.4;         % [-]
initial.b_o = 6.2;          % [m]
initial.sweep_o = 22.73;    % [deg]
initial.twist_k = 1;        % [deg]
initial.twist_t = 1;        % [deg]
initial.CST_r = [0.2337    0.0800    0.2674    0.0899    0.2779    0.3816 ...
                -0.2253   -0.1637   -0.0464   -0.4778    0.0741    0.3252];
initial.CST_t = [0.1390    0.0476    0.1591    0.0534    0.1653    0.2270 ...
                -0.1340   -0.0974   -0.0276   -0.2842    0.0441    0.1935];

x0 = [initial.c_r ...
    initial.tr_i ...
    initial.tr_o ...
    initial.b_o ...
    initial.sweep_o ...
    initial.twist_k ...
    initial.twist_t ...
    initial.CST_r ... 
    initial.CST_t];

% Wing parameters
inputs.b_i = 3.8;       % [m]   Measured
inputs.sweep_i = 0;     % [deg] Placeholder
inputs.dihedral = 0;    % [deg] Placeholder
inputs.incidence = 0;   % [deg] Placeholder
inputs.c_fs = 0.15;     % [%c]  Taken from assignment
inputs.c_rs = 0.6;      % [%c]  Taken from assignment
inputs.b_ft0 = 0;       % [%b/2]Taken from assignment
inputs.b_ft1 = 0.85;    % [%b/2]Taken from assignment
inputs.rib_pitch = 0.5; % [m]   Taken from assignment

% Engine parameters - All values zero because engines are not wing-mounted
inputs.N_e = 0;
inputs.b_e = 0;
inputs.W_e = 0;

% Material parameters
inputs.E_al = 70*10^3;  % [N/mm^2] Taken from assignment
inputs.sigma_t = 295;   % [N/mm^2] Taken from assignment
inputs.sigma_c = 295;   % [N/mm^2] Taken from assignment
inputs.rho_al = 2800;   % [kg/m^3] Taken from assignment

% Aerodynamic parameters
inputs.h_cr = 37000*0.3048; % Taken from source 1
[inputs.T_cr,inputs.a_cr,inputs.P_cr,inputs.rho_cr] = atmosisa(inputs.h_cr);
inputs.mu_cr = 1.458*10^-6*inputs.T_cr^(3/2)/(inputs.T_cr+110.4);
inputs.V_MO = 0.76*inputs.a_cr; % Taken from source 1 and transformed from IAS to TAS
inputs.V_cr = 367*0.514444; % Taken from source 1

% Performance parameters
inputs.R = 1620 * 1.852;        % [km]      Taken from source 1
inputs.C_T = 1.8639*10e-4;      % [N/Ns]    Taken from assignment
inputs.CL_CD = 16;              % [-]       Taken from assignment

% Fuel tank parameters
inputs.f_tank = 0.93;           % [-]       Taken from assignment
inputs.rho_fuel = 0.81715*10^3; % [kg/m^3]  Taken from assignment

% Weight parameters
inputs.MTOW = 19200 * 9.81;                     % [N]   Taken from source 1
inputs.ZFW = inputs.MTOW - 2865 * 9.81;         % [N]   Taken from source 1
inputs.W_des = sqrt(inputs.MTOW * inputs.ZFW);  % [N]   Calculated

% aircraft-less-wing parameters
inputs.W_AW = inputs.ZFW - Structures(x0, inputs.MTOW); 
inputs.D_AW = (1 / inputs.CL_CD - Aerodynamics(x0, inputs.W_des, true)) * inputs.W_des;
