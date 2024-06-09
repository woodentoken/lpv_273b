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
% set(gca, 'XColor','k', 'YColor','k');set(gcf, 'Color','w')

%% H infinity control design
% this is used to find an adequate crossover frequency combination for the
% H infinity controller that results in good low frequency tracking
% performance
% clearvars;
saved_path = 'saved_trim_states/';
files = dir(fullfile(saved_path, "*.mat"));
i=1;
[saved_path files(i).name]
load([saved_path files(i).name])
% 
% xover = logspace(-3, 3, 7);
% w_range =  logspace(-5, 5, 500);
% figure(100)
% for i = 1:length(xover)
%     norm_i = (i-1)/(length(xover)-1);
%     color = [norm_i 0 1-norm_i];
%     [ltf] = hinfloop(ac.mimo_system, [0.2, 10*xover(i), 300], [6000, xover(i), 0.2], [20]);
%     [SV, W] = sigma(ltf.Ty,w_range);
%     semilogx(W, SV(1,:)./SV(2,:) , 'Color', color, 'DisplayName', ['Crossover: ' num2str(xover(i))])
%     hold on
% end
% legend('Location', 'best');
% ylim([1 2])
% grid on
% hold off

%% plotting with performance tuned controller
perf.wd = [0.2, 1, 500];
perf.wp = [6000, 10, 0.2];
perf.wu = [20];

% p = ureal('p',10,'Percentage',10);
% A = [0 p;-p 0];
% B = eye(2);
% C = [1 p;-p 1];
% H = ss(A,B,C,[0 0;0 0])
% W1 = makeweight(.1,20,50);
% W2 = makeweight(.2,45,50);
% Delta1 = ultidyn('Delta1',[1 1]);
% Delta2 = ultidyn('Delta2',[1 1]);
% 
% H = ac.mimo_system
% G = H*blkdiag(1+W1*Delta1,1+W2*Delta2)
% G = uss(G)

[ltf_performant] = hinfloop(ac.mimo_system, perf);
[ninf_p, fpeak_p] = hinfnorm(ltf_performant.Tzw)
figure(2)
sgtitle('Performant H_{\infty} Controller')
hinfplotting(ltf_performant, {1e-3, 1e4})
ac.ltf_performant = ltf_performant;

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

% save with computed Hinf controllers
save('saved_trim_states/' + alpha_condition + '_alpha_trim')

%% performance comparison

%% robustness comparison
