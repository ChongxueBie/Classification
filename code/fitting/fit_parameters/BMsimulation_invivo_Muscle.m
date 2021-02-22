% set initial values of CEST and MT pools (required for numeric solution)

% do the following to initialize, or call 
close all
clear all
addpath(genpath(pwd));
Sim=init_Sim(struct());


%%

Sim.n_cest_pool=5;

Sim.dwA=0.;
Sim.R1A=1/1.28;
Sim.R2A=1/0.0133;
  
% Cr pool B (Cr)
Sim.n_cest_pool=1;
Sim.fB=0.0014;  % rel. conc 100mM/111M
Sim.kBA=500;   % exchange rate in Hz ( the fast one, kBA is calculated by this and fB)
Sim.dwB=2.0;     % ppm  relative to dwA
Sim.R1B=1;      % R1B relaxation rate [Hz]
Sim.R2B=1/5.4e-3;     % R2B relaxation rate [Hz]

%MT
Sim.MT                = 1;                % 1 = with MT pool (pool C), 0 = no MT pool
Sim.MT_lineshape      = 'Lorentzian';       % MT lineshape - cases: SuperLorentzian, Gaussian, Lorentzian
Sim.R1C=1;
Sim.fC=10700/111000;
Sim.dwC=0;
Sim.R2C=1/5e-5;  % 1/9.1�s
Sim.kCA=15; 
Sim.kAC=Sim.kCA*Sim.fC;

% amide pool D
Sim.n_cest_pool=2;
Sim.fD=0.0018;  % rel. conc 190mM/111M
Sim.kDA=50;   % exchange rate in Hz ( the fast one, kBA is calculated by this and fB)
Sim.dwD=3.5;     % ppm  relative to dwA
Sim.R1D=1;      % R1B relaxation rate [Hz]
Sim.R2D=1/1.3e-3;     % R2B relaxation rate [Hz]

% PCr pool E
Sim.n_cest_pool=3;
Sim.fE=0.0008;  % rel. conc 180mM/111M
Sim.kEA=160;   % exchange rate in Hz ( the fast one, kBA is calculated by this and fB)
Sim.dwE=2.65;     % ppm  relative to dwA
Sim.R1E=1;      % R1B relaxation rate [Hz]
Sim.R2E=1/9.3e-3;     % R2B relaxation rate [Hz]

% NOE pool F
Sim.n_cest_pool=4;
Sim.fF=145/111000;  % rel. conc 35mM/111M
Sim.kFA=45;   % exchange rate in Hz ( the fast one, kBA is calculated by this and fB)
Sim.dwF=-3.5;     % ppm  relative to dwA
Sim.R1F=1;      % R1B relaxation rate [Hz]
Sim.R2F=1/5.6e-4;     % R2B relaxation rate [Hz]

% 5 CEST pool G (-2.3 MT)
Sim.n_cest_pool=5;
Sim.fG=5500/111000;  % rel. conc 35mM/111M
Sim.kGA=15;   % exchange rate in Hz ( the fast one, kBA is calculated by this and fB)
Sim.dwG=-2.3;     % ppm  relative to dwA
Sim.R1G=1;      % R1B relaxation rate [Hz]Sim.R2G=1/7e-5;     % R2B relaxation rate [Hz]
Sim.R2G=1/7e-5;     % R2B relaxation rate [Hz]

Sim.FREQ=500;
Sim.Zi=1.;
Sim.B1=0.28;		 % the saturation B1 in �T
Sim.tp=4;		 % [s]
Sim.n=1;	
Sim.DC=1;
Sim.shape='block';		 
Sim.pulsed=0;		

Sim.xZspec = linspace(-6, 6, 81);%-5:0.1:5;

Sim.n_cest_pool=5;
Sim.analytic          = 1;                % calculate analtical solution? 1=yes, 0=no
Sim.numeric           = 0;                % calculate numerical solution? 1=yes, 0=no
Sim.MT                = 1;                % 1 = with MT pool (pool C), 0 = no MT pool
Sim.Rex_sol           = 'Hyper';          % solution for Rex - cases: 'Hyper', 
Sim.MT_lineshape      = 'Lorentzian';       % MT lineshape -SuperLorentzian, Gaussian, Lorentzian
Sim.MT_sol_type       = 'Rex_MT';         % Rex_MT solution type - cases: 'Rex_MT'
Sim.B1cwpe_quad   = -1;                     %XX
Sim.c     = 1;                              %XX
Sim.dummies=1; 
Sim.flipangle=5; 
% Sim.readout='FID'; 
Sim.spoilf=0; 
 %% plot multi-power
B1 = [0.5, 1.0, 2.0];
% B1 = [2.0];
simData = zeros(3, length(Sim.xZspec));
fig = figure(1); subplot(5,2,[1,2,3,4,5,6,7,8]);
hold on; box on;
for i = 1: length(B1)
    Sim.B1 = B1(i);
    ana = ANALYTIC_SIM(Sim);
    simData(i,:) = ana.zspec;
    figure(1), plot(ana.x,ana.zspec*100,'k.-'); hold on
end
%%
path = "/Users/cbie1/OneDrive - Johns Hopkins/JHU/CEST/Machine_Learning_BreastTumor/double_tumor/material_paper/20200824/M3_2/M3_2_Ztab_Muscle_back.mat";
expdata = load(path);
expdata = (expdata.Ztab_Muscle);
expfreq = linspace(-6, 6, 81);

resd = zeros(3, length(Sim.xZspec));
for i = 1:length(B1)
    resd(i,:) = squeeze(expdata(i, :)) - squeeze(simData(i,:));
end
resdAll = mean(resd);

for i = 1: 3
    figure(1),plot(expfreq, squeeze(expdata(i, :))*100,'ko')
end

legend({'0.5\muT', '1.0\muT', '2.0\muT'},'Location','southeast')
% xticks('')
set(gca,'XDir','reverse')
set(gca,'xticklabel',[])
ylim([0,100])
ylabel('S/S_0 (%)')
set(gca,'Fontsize',20)
title('Muscle','Fontsize',25)


grid on

subplot(subplot(5,2,9:10)); hold on; box on;
plot(expfreq, resdAll*100, 'k')
set(gca,'XDir','reverse')

xlim([-6, 6])
ylim([-4,4]) 
yticks([-4 0 4])
set(gca,'yticklabel',{'-4', '0', '4'})

xlabel('Saturation Frequency (ppm)') 
ylabel('Residual (%)')
set(gca,'Fontsize',20)
set(gcf,'Position',[100 100 600 600])

%%
% savedir = '/Users/cbie1/Documents/CEST_Machine_learning_BreastTumor/Results/double_tumor_mouse/simulation_matlab';
% saveSimData = [savedir, '/sim_Muscle.mat'];
% save(saveSimData,'simData');

%% goodness of fit
r2 = zeros(3, 1);
for i = 1:length(B1)
    y = squeeze(expdata(i, :));
    y_fit = squeeze(simData(i,:));
    ss_res = sum((y - y_fit).^2);
    ss_tot = sum((y - mean(y)).^2);
    r2(i) = 1 - (ss_res / ss_tot);
end
r2All = mean(r2);
