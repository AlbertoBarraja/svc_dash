clear all;
close all;

%%
%plot(X,Y);

%time
time_slot_less=[ 0 10 20 30 40 50 60 70];
time_slot_more=[ 0 10 20 30 40 50 60 ];
time_slot_horizontal=[ 0 10 20 30 40 50 60 70 80 90];
time_slot_realtime=[ 0 10 20 30 40 50 60 70 80];
time_slot_vertical=[0 10 20]


% average quality diagonal less steeplty 
y_diag_less=[1.1 1.9 2.0333 2.0666 2.1 2.5333 2.9 3];

% average quality diagonal more steeplty 
y_diag_more=[ 1.1 1.53333 2.1 2.16666 2.233333 2.566666 3 ];

% average quality pure horizontal
y_horizontal=[ 1 1 1 1.1333 1.4 1.6666 1.9666 2 2.7333 3];

% average quality real time
y_realtime=[ 2.2 2.2 2.23333 2.33333 2.33333 2.4 2.6 2.8 3];

% average quality real time
y_vertical=[ 2.1 2.3 3];

hold on

line(time_slot_less,y_diag_less, 'LineStyle','-','Linewidth',2,'Color',[0 0 0]);
line(time_slot_more,y_diag_more, 'LineStyle','--','Linewidth',2,'Color',[0 0 0]);
line(time_slot_horizontal,y_horizontal,'LineStyle',':','Linewidth',2,'Color',[0 0 0]);
line(time_slot_realtime,y_realtime, 'LineStyle','-.','Linewidth',2,'Color',[0 1 0]);
line(time_slot_vertical,y_vertical, 'LineStyle','--','Linewidth',2,'Color',[1 0 0]);


%line(x_4,y_4,'Color','k','Linewidth',2);
ylim([0 3])
title('Average quality estimation, network speed from 200Kb/s to 3500Kb/s');
xlabel('Time (s)');
ylabel('Layer Number');
set(gca,'ytick', [1 2 3 4]);
legend('diagonal less steeply policy','diagonal more steeply policy','pure horizontal policy','realtime policy', 'pure vertical policy');

grid minor;

%%