clear all;
close all;

%%
%plot(X,Y);

%time
time_slot_less=[ 0 70 90 100 110 120 140 160 170 180 210 240 270 300 330 350];
time_slot_more=[ 0 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 240 270 300 330 360 370 ];
time_slot_horizontal=[ 0 70 90 100 110 120 140 150 180 210 240 270 300 330 360 380];
time_slot_realtime=[ 0 70 100 130 160 220 230 240 270 300 330 350];
time_slot_vertical=[0 60 120 180 240 270 300];


% average quality diagonal less steeplty 
y_diag_less=[1.0666 1.1333 1.3 1.4 1.4666 1.5 1.733 1.8333 2.0333 2.0333 2.0333 2.1 2.2666 2.5 2.76666 3];

% average quality diagonal more steeplty 
y_diag_more=[ 1.0666 1.0666 1.0666 1.0666 1.0666 1.0666 1.0666 1.1333 1.1333 1.1666 1.3666 1.466 1.5 1.5 1.733 1.766 1.8 2.0333 2.0333 2.1 2.26666 2.46666 2.6333 2.8 3];

% average quality pure horizontal
y_horizontal=[ 1 1.1 1.1333 1.36666 1.4333 1.4666 1.6 1.7 1.9333333 2 2 2.16333 2.4333 2.6333 2.8 3];

% average quality real time
y_realtime=[ 1.333 1.3666 1.7 1.9333  2.13333 2.2 2.26666 2.4 2.5333 2.7333 2.9333 3];

% average quality real time
y_vertical=[ 1.4666 1.5666 1.9333 2.13333 2.5666 2.7 3];

hold on

line(time_slot_less,y_diag_less, 'LineStyle','-','Linewidth',2,'Color',[0 0 0]);
line(time_slot_more,y_diag_more, 'LineStyle','--','Linewidth',2,'Color',[0 0 0]);
line(time_slot_horizontal,y_horizontal,'LineStyle',':','Linewidth',6,'Color',[0 0 0]);
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