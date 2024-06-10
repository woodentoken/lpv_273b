function [] = hinfplotting(ltf, omega_range)
% HINFPLOTTING This function automates the generation of charts created via
% the hinfloop function so they are consistent and repeatable.

% define some standard colors in one place so we can reapply as needed
Ly_color = 'k-.';
Ty_color = 'g';
Sy_color = 'r';
Y_color = 'b';

set(0,'DefaultAxesFontSize',16)
set(0, 'DefaultAxesFontWeight', 'bold')

%% plotting
%set(gca, 'Color','k', 'XColor','w', 'YColor','w');set(gcf, 'Color','k')
opts = sigmaoptions;
opts.Ylim = [-80, 60];
legend_location = 'east';
fs = 14;

if isuncertain(ltf.Ty)
    %% uncertainty
    subplot(3,1,3)
    sigma( ...
        ltf.Ly, Ly_color, ...
        ltf.Gp, '', ...
        ltf.Gc,'', ...
        omega_range,...
        opts...
        )
    legend('Ly', 'Gp', 'Gc','Location', legend_location)
    grid
    title('(c) Open Loop Characteristics')

    subplot(3,1,2)
    sigma( ...
        ltf.Lu, Ly_color, ...
        ltf.Su, Sy_color, ...
        ltf.Tu, Ty_color, ...
        omega_range,...
        opts...
        )
    hold on
    legend( 'Lu', 'Su','Tu', 'Location', legend_location)
    grid
    title('(b) Input Sensitivity Characteristics')

    subplot(3,1,1)
    sigma( ...
        ltf.Ly, Ly_color, ...
        ltf.Sy, Sy_color, ...
        ltf.Ty, Ty_color, ...
        ltf.Y, Y_color, ...
        omega_range,...
        opts...
        )
    legend( 'Ly', 'Sy','Ty', 'Youla','Location', legend_location)
    grid
    title('(a) Output Sensitivity Characteristics')
    set(findall(gcf,'-property','FontSize'),'FontSize',fs)
    %saveas(gcf, ['plots/' title '_uncertain_sensitivities.png'])

    figure()
    subplot(2,1,1)
    step(ltf.Ty, 'g', ltf.Ty.NominalValue, 'r');
    legend('Uncertainty', 'No Uncertainty', 'Location', legend_location)

    grid
    title('Output Step Response')

    subplot(2,1,2)
    step(ltf.Y, 'b', ltf.Y.NominalValue, 'r');
    legend('Uncertainty', 'No Uncertainty', 'Location', legend_location)
    grid
    title('Actuation Step Response')
    set(findall(gcf,'-property','FontSize'),'FontSize',fs)
    %saveas(gcf, ['plots/' title '_uncertain_step.png'])


else
    %% no uncertainty
    subplot(3,1,3)
    sigma( ...
        ltf.Ly, Ly_color, ...
        ltf.Gp, '', ...
        ltf.Gc,'', ...
        omega_range,...
        opts...
        )
    legend('Ly', 'Gp', 'Gc','Location', legend_location)
    grid
    title('(c) Open Loop Characteristics')

    subplot(3,1,2)
    sigma( ...
        ltf.Lu, Ly_color, ...
        ltf.Su, Sy_color, ...
        ltf.Tu, Ty_color, ...
        omega_range,...
        opts...
        )
    hold on
    legend( 'Lu', 'Su','Tu', 'Location', legend_location)
    grid
    title('(b) Input Sensitivity Characteristics')

    subplot(3,1,1)
    sigma( ...
        ltf.Ly, Ly_color, ...
        ltf.Sy, Sy_color, ...
        ltf.Wp, [Sy_color '--'], ...
        ltf.Ty, Ty_color, ...
        ltf.Wd, [Ty_color '--'],...
        ltf.Y, Y_color, ...
        ltf.Wu, [Y_color '--'], ...
        omega_range,...
        opts...
        )
    legend( 'Ly', 'Sy', 'Wp','Ty', 'Wd', 'Youla', 'Wu','Location', legend_location)
    grid
    title('(a) Output Sensitivity Characteristics')
    set(findall(gcf,'-property','FontSize'),'FontSize',fs)
    % saveas(gcf, ['plots/' title '_sensitivities.png'])

    figure()
    subplot(2,1,1)
    step(ltf.Ty, 'g');
    grid
    title('Output Step Response')

    subplot(2,1,2)
    step(ltf.Y, 'b');
    grid
    title('Actuation Step Response')
    set(findall(gcf,'-property','FontSize'),'FontSize',fs)
    % saveas(gcf, ['plots/' title '_step.png'])
end
end