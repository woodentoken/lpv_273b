clearvars; close all; clc

% files = dir(fullfile('saved_trim_states/', "*.mat"));
% 
% % plot the open loop plant singular values for each trim condition
% for i = 1:1
%     load([saved_path files(i).name])
%     sigma(ac.mimo_system/ac.trim.airspeed)
%     % hold on
%     %clear ac
% end
% h = legend('$G{\alpha}=0$', '$G\alpha=10$', '$G\alpha=5$', 'location', 'best');
% set(h, 'Interpreter', 'latex');
% title('Open Loop System Singular Values, normalized by trim airspeed')
% grid on

%% H infinity control design
saved_path = 'saved_trim_states/';
files = dir(fullfile(saved_path, "*.mat"));

load("saved_trim_states/0_alpha_trim.mat")
alpha_condition = num2str(ac.trim.alpha_deg);

file = [saved_path alpha_condition '_alpha_trim.mat']
load(file)

%% plotting with performance tuned controller
perf.wd = [0.5, 10, 100];
perf.wp = [200, 1, 0.5];
perf.wu = [5];

figure()
sgtitle('Performant H_{\infty} Controller')
[ltf_performant] = hinfloop(ac.mimo_system, perf);
[ninf_p, fpeak_p] = hinfnorm(ltf_performant.Tzw)
hinfplotting(ltf_performant, {1e-3, 1e4})
ac.ltf_performant = ltf_performant;

%ac.ltf_performant.bandwidth = neo_classical_bandwidth(ac.ltf_performant.Sy, alpha)

%% robustness 
robust.wd = [0.1, 1, 500];
robust.wp = [700, 0.1, 0.9];
robust.wu = [1];

figure()
sgtitle('Robust H_{\infty} Controller')
[ltf_robust] = hinfloop(ac.mimo_system, robust);
[ninf_r, fpeak_r] = hinfnorm(ltf_robust.Tzw)
hinfplotting(ltf_robust, {1e-3, 1e4})
ac.ltf_robust = ltf_robust;

%ac.ltf_robust.bandwidth = neo_classical_bandwidth(ac.ltf_robust.Sy, alpha)

%% clean up
% save with computed Hinf controllers

figure()
subplot(2,1,1)
sigma(ac.ltf_performant.Ty, 'g', ac.ltf_performant.Sy, 'r', ac.ltf_performant.Y, 'b', ac.ltf_performant.Ly, 'k-.', {1e-3, 1e3})
title('Performant H\infty Controller Characteristics')
grid on

subplot(2,1,2)
sigma(ac.ltf_robust.Ty, 'g', ac.ltf_robust.Sy, 'r', ac.ltf_robust.Y, 'b', ac.ltf_robust.Ly, 'k-.', {1e-3, 1e3})
legend('Ty', 'Sy', 'Y', 'Open Loop')
title('Robust H\infty Controller Characteristics')
grid on

%%
save('saved_trim_states/' + alpha_condition + '_alpha_trim')

%% performance comparison

%% robustness comparison
