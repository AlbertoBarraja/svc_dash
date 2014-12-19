clear all;
close all;

%%
%plot(X,Y);

%time
time_slot_less=[ 0 20 40 60 80 100 120 140 160 180 200 210];
time_slot_more=[ 0 20 40 60 80 100 120 140 160 180 200 220 240 ];
time_slot_realtime=[ 0 20 40 60 80 100 120 140 160 180 200 220 242 ];
time_slot_vertical=[ 0 20 40 60 80 100 120 140 160 180 182];
time_slot_horizontal=[0 20 40 60 80 100 120 140 160 182 200 220 240 260 280 300];


% average quality diagonal less steeplty 
y_diag_less=[0 1 0 0 0 1 1 1 1 1 1 0 ];

% average quality diagonal more steeplty 
y_diag_more=[0 1 1 1 0 0 0 1 1 1 1 1 0];

% average quality pure horizontal
y_horizontal=[0 0 0 0 1 1 0 0 0 1 1 1 1 1 1 1];

% average quality real time
y_realtime=[12 12 12 3 0 0 0 1 1 1 1 1 0];

% average quality real time
y_vertical=[14 10 10 9 8 7 6 7 4 1 0 ];

hold on

line(time_slot_less,y_diag_less, 'LineStyle','-','Linewidth',2,'Color',[0 0 0]);
line(time_slot_more,y_diag_more, 'LineStyle','--','Linewidth',2,'Color',[0 0 0]);
line(time_slot_horizontal,y_horizontal,'LineStyle',':','Linewidth',6,'Color',[0 0 0]);
line(time_slot_realtime,y_realtime, 'LineStyle','-.','Linewidth',4,'Color',[0 1 0]);
line(time_slot_vertical,y_vertical, 'LineStyle','--','Linewidth',2,'Color',[1 0 0]);


%line(x_4,y_4,'Color','k','Linewidth',2);
ylim([0 16])
title('Quality switches estimation, network speed from 200Kb/s to 3500Kb/s', 'FontSize', 14);
xlabel('Time (s)', 'FontSize', 14);
ylabel('Layer Number', 'FontSize', 14);
%set(gca,'ytick', [1 2 3 4]);
set(gca,'fontsize',14);
legend('diagonal less steeply policy','diagonal more steeply policy','pure horizontal policy','realtime policy', 'pure vertical policy');

grid minor;

%%