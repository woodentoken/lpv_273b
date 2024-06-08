%tfm = ac.tfm;
%Gss = ac.mimo_system;
clearvars;

saved_path = 'saved_trim_states/';
files = dir(fullfile('saved_trim_states/', "*.mat"));

for i = 1:length(files)
    load([saved_path files(i).name])
    sigma(ac.mimo_system)
    hold on
    clear ac
end
h = legend('$G{\alpha}=0$', '$G\alpha=5$', '$G\alpha=10$', 'location', 'best');
set(h, 'Interpreter', 'latex');
grid on
% set(gca, 'XColor','k', 'YColor','k');set(gcf, 'Color','w')
clear ac

%% H infinity control design
load([saved_path files(i).name])

xover = logspace(0.01, 1000, 5);

figure(100)
hold on
for i = 1:length(xover)
    [ltf] = hinfloop(ac.mimo_system, [0.5, xover(i), 600], [600, 100/xover(i), 0.5]);
    [SV,W] = sigma(ltf.Ty);
    plot(W, 20*log10(SV/20))
end
%hinfplotting(ltf)

%figure()
%sigma(ltf.Ty);



%% plotting