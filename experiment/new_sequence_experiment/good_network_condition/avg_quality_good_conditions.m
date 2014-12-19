clear all;
close all;

%%
%plot(X,Y);

%time
time_slot_less=[ 0 10 20 30 40 50 56];
time_slot_more=[ 0 10 20 30 40 50 54 ];
time_slot_realtime=[ 0 10 20 30 40 50 60 70 80];
time_slot_vertical=[ 0 10 20 24];
time_slot_horizontal=[0 10 20 30 40 50 60 70 80 90];


% average quality diagonal less steeplty 
y_diag_less=[1.531 2.03 2.09 2.09 2.09 2.75 3 ];

% average quality diagonal more steeplty 
y_diag_more=[ 1.031 1.825 2.25 2.25 2.25 2.8125 3 ];

% average quality pure horizontal
y_horizontal=[ 1 1 1.0625 1.3125 1.53125 1.75 1.96875 2 2.468 3 ];

% average quality real time
y_realtime=[ 1.875 1.906 1.968 1.968 2 2.03 2.09 2.75 3 ];

% average quality real time
y_vertical=[ 1.875 2.3125 2.5625 3];

hold on

line(time_slot_less,y_diag_less, 'LineStyle','-','Linewidth',2,'Color',[0 0 0]);
line(time_slot_more,y_diag_more, 'LineStyle','--','Linewidth',2,'Color',[0 0 0]);
line(time_slot_horizontal,y_horizontal,'LineStyle',':','Linewidth',6,'Color',[0 0 0]);
line(time_slot_realtime,y_realtime, 'LineStyle','-.','Linewidth',2,'Color',[0 1 0]);
line(time_slot_vertical,y_vertical, 'LineStyle','--','Linewidth',2,'Color',[1 0 0]);


%line(x_4,y_4,'Color','k','Linewidth',2);
ylim([0 3])
title('Average quality estimation, network speed from 200Kb/s to 3500Kb/s', 'FontSize', 14);
xlabel('Time (s)', 'FontSize', 14);
ylabel('Layer Number', 'FontSize', 14);
set(gca,'ytick', [1 2 3 4]);
set(gca,'fontsize',14);
legend('diagonal less steeply policy','diagonal more steeply policy','pure horizontal policy','realtime policy', 'pure vertical policy');

grid minor;

%%