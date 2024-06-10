clearvars; close all; clc

saved_path = 'saved_trim_states/';
files = dir(fullfile('saved_trim_states/', "*.mat"));

% plot the open loop plant singular values for each trim condition
for i = 1:1
    load([saved_path files(i).name])
    sigma(ac.mimo_system/ac.trim.airspeed)
    hold on
    %clear ac
end
h = legend('$G{\alpha}=0$', '$G\alpha=10$', '$G\alpha=5$', 'location', 'best');
set(h, 'Interpreter', 'latex');
title('Open Loop System Singular Values, normalized by trim airspeed')
grid on

%% H infinity control design
saved_path = 'saved_trim_states/';
files = dir(fullfile(saved_path, "*.mat"));
i=1;
[saved_path files(i).name]
load([saved_path files(i).name])

%% plotting with performance tuned controller
perf.wd = [0.2, 1, 500];
perf.wp = [6000, 10, 0.2];
perf.wu = [20];

[ltf_performant] = hinfloop(ac.mimo_system, perf);
[ninf_p, fpeak_p] = hinfnorm(ltf_performant.Tzw)
figure(2)
sgtitle('Performant H_{\infty} Controller')
hinfplotting(ltf_performant, {1e-3, 1e4})
ac.ltf_performant = ltf_performant;

%ac.ltf_performant.bandwidth = neo_classical_bandwidth(ac.ltf_performant.Sy, alpha)

%% robustness 
robust.wd = [0.1, 1, 500];
robust.wp = [700, 0.1, 0.9];
robust.wu = [1];

figure(3)
sgtitle('Robust H_{\infty} Controller')
[ltf_robust] = hinfloop(ac.mimo_system, robust);
[ninf_r, fpeak_r] = hinfnorm(ltf_robust.Tzw)
hinfplotting(ltf_robust, {1e-3, 1e4})
ac.ltf_robust = ltf_robust;

%ac.ltf_robust.bandwidth = neo_classical_bandwidth(ac.ltf_robust.Sy, alpha)

%% clean up
% save with computed Hinf controllers
save('saved_trim_states/' + alpha_condition + '_alpha_trim')

%% performance comparison

%% robustness comparison
