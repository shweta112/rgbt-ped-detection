%% Input parameters
% pLoad={'lbls',{'person'},'ilbls',{'people','person?','cyclist'},'squarify',{3,.41}};
% pLoadReasonable = [pLoad, 'hRng',[45 inf],...
%     'vRng',[1 1],'xRng',[5 635],'yRng',[5 475]];
c = [[0, 0, 1]; 	          	
     [1, 0, 0];	          	
     [0.9290, 0.6940, 0.1250]; 	          	
     [0.4940, 0.1840, 0.5560]; 	          	
     [0.4660, 0.6740, 0.1880]; 	          	
     [0.3010, 0.7450, 0.9330]; 	          	
     [0.6350, 0.0780, 0.1840]];


gt0 = load('/media/shweta.mahajan/Daten/gt0.mat');
gt0 = gt0.gt0;

gta = load('/media/shweta.mahajan/Daten/gta.mat');
gta = gta.gta;

%% Load our detections
dtFRCNN = load('/media/shweta.mahajan/Daten/dt_FRCNN.mat');
dtFRCNN = dtFRCNN.dt0;
dtSSD = load('/media/shweta.mahajan/Daten/dt_SSD.mat');
dtSSD = dtSSD.dt0;

%% Load other detections
dtKAIST = load('/media/shweta.mahajan/Transcend2TB/illumination-aware_multispectral_pedestrian_detection/dt-ACF+C+T.mat');
dtKAIST = dtKAIST.dt;

% MR 29.83
dtFusionRPN = load('/media/shweta.mahajan/Transcend2TB/illumination-aware_multispectral_pedestrian_detection/dt-Fusion_RPN+BDT.mat');
dtFusionRPN = dtFusionRPN.dt;

% MR 37
dtHalfway = load('/media/shweta.mahajan/Transcend2TB/illumination-aware_multispectral_pedestrian_detection/dt-Halfway_Fusion.mat');
dtHalfway = dtHalfway.dt;

dtMSDS = load('/media/shweta.mahajan/Daten/dt_MSDS.mat');
dtMSDS = dtMSDS.dt0;

%% Load the bbs and evaluate
[gt, dt_FRCNN] = bbGt('evalRes', gt0, dtFRCNN);
[~, dt_SSD] = bbGt('evalRes', gt0, dtSSD);
[~, dt_K] = bbGt('evalRes', gt0, dtKAIST);
[~, dt_FusionRPN] = bbGt('evalRes', gt0, dtFusionRPN);
[~, dt_Halfway] = bbGt('evalRes', gt0, dtHalfway);
[~, dt_MSDS] = bbGt('evalRes', gt0, dtMSDS);

% [gt, dt_FRCNN] = bbGt('evalRes', gta, dtFRCNN);
% [~, dt_SSD] = bbGt('evalRes', gta, dtSSD);
% [~, dt_K] = bbGt('evalRes', gta, dtKAIST);
% [~, dt_FusionRPN] = bbGt('evalRes', gta, dtFusionRPN);
% [~, dt_Halfway] = bbGt('evalRes', gta, dtHalfway);
% [~, dt_MSDS] = bbGt('evalRes', gta, dtMSDS);

clf;

%% Calculate miss-rate and visualize graph
rec = (0:.1:1);
rng = 10.^(-2:.25:0);
lims = [2e-4 50 0 1];

[fp,tp,score,miss] = bbGt('compRoc',gt,dt_K,1,rng);
miss=exp(mean(log(max(1e-10,1-miss)))); 
str(1) = {sprintf('%.2f%% ACF + T + THOG',miss*100)};
hs(1) = plotRoc([fp tp],'logx',1,'logy',1,'xLbl','FPPI', 'yLbl', 'Miss rate',...
  'lims',lims,'color',c(1,:),'smooth',0,'fpTarget',rng,'lineWd', 2);

[fp,tp,score,miss] = bbGt('compRoc',gt,dt_Halfway,1,rng);
miss=exp(mean(log(max(1e-10,1-miss))));
str(2) = {sprintf('%.2f%% Halfway Fusion',miss*100)};
hs(2) = plotRoc([fp tp],'logx',1,'logy',1,'xLbl','FPPI', 'yLbl', 'Miss rate',...
  'lims',lims,'color',c(2,:),'smooth',0,'fpTarget',rng,'lineWd', 2);


[fp,tp,score,miss] = bbGt('compRoc',gt,dt_FusionRPN,1,rng);
miss=exp(mean(log(max(1e-10,1-miss)))); 
str(3) = {sprintf('%.2f%% Fusion RPN + BDT',miss*100)};
hs(3) = plotRoc([fp tp],'logx',1,'logy',1,'xLbl','FPPI', 'yLbl', 'Miss rate',...
  'lims',lims,'color',c(3,:),'smooth',0,'fpTarget',rng,'lineWd', 2);

[fp,tp,score,miss] = bbGt('compRoc',gt,dt_MSDS,1,rng);
miss=exp(mean(log(max(1e-10,1-miss))));
str(4) = {sprintf('%.2f%% MSDS-RCNN',miss*100)};
hs(4) = plotRoc([fp tp],'logx',1,'logy',1,'xLbl','FPPI', 'yLbl', 'Miss rate',...
  'lims',lims,'color',c(4,:),'smooth',0,'fpTarget',rng,'lineWd', 2);

[fp,tp,score,miss] = bbGt('compRoc',gt,dt_FRCNN,1,rng);
miss=exp(mean(log(max(1e-10,1-miss)))); 
str(5) = {sprintf('%.2f%% Faster R-CNN Resnet101(ours)',miss*100)};
hs(5) = plotRoc([fp tp],'logx',1,'logy',1,'xLbl','FPPI', 'yLbl', 'Miss rate',...
  'lims',lims,'color',c(5,:),'smooth',0,'fpTarget',rng,'lineWd', 2);

[fp,tp,score,miss] = bbGt('compRoc',gt,dt_SSD,1,rng);
miss=exp(mean(log(max(1e-10,1-miss))));
str(6) = {sprintf('%.2f%% SSD MobilenetV2(ours)',miss*100)};
hs(6) = plotRoc([fp tp],'logx',1,'logy',1,'xLbl','FPPI', 'yLbl', 'Miss rate',...
  'lims',lims,'color',c(6,:),'smooth',0,'fpTarget',rng,'lineWd', 2);

leg = legend(hs, str, 'Location', 'southwest');
leg.ItemTokenSize = [16 18];
savefig('Roc_eval_r', 'png');

%% Calculate mAP and visualize graph
clf;

[fp1,tp1,score1,ap] = bbGt('compRoc',gt,dt_K,0,rec);
map = sum(ap)/length(ap);
str(1) = {sprintf('%.2f%% ACF + T + THOG',map*100)};
hs(1) = plot(rec, ap, 'Color', c(1,:), 'LineWidth', 2); 

hold on; xlabel('Recall'); ylabel('Precision'); grid on;

[fp1,tp1,score1,ap] = bbGt('compRoc',gt,dt_Halfway,0,rec);
map = sum(ap)/length(ap);
str(2) = {sprintf('%.2f%% Halfway Fusion',map*100)};
hs(2) = plot(rec, ap, 'Color', c(2,:), 'LineWidth', 2);

[fp1,tp1,score1,ap] = bbGt('compRoc',gt,dt_FusionRPN,0,rec);
map = sum(ap)/length(ap);
str(3) = {sprintf('%.2f%% Fusion RPN + BDT',map*100)};
hs(3) = plot(rec, ap, 'Color', c(3,:), 'LineWidth', 2);

[fp1,tp1,score1,ap] = bbGt('compRoc',gt,dt_MSDS,0,rec); 
map = sum(ap)/length(ap);
str(4) = {sprintf('%.2f%% MSDS-RCNN',map*100)};
hs(4) = plot(rec, ap, 'Color', c(4,:), 'LineWidth', 2);

[fp1,tp1,score1,ap] = bbGt('compRoc',gt,dt_FRCNN,0,rec);
map = sum(ap)/length(ap);
str(5) = {sprintf('%.2f%% Faster R-CNN Resnet101(ours)',map*100)};
hs(5) = plot(rec, ap, 'Color', c(5,:), 'LineWidth', 2);

[fp1,tp1,score1,ap] = bbGt('compRoc',gt,dt_SSD,0,rec);
map = sum(ap)/length(ap);
str(6) = {sprintf('%.2f%% SSD MobilenetV2(ours)',map*100)};
hs(6) = plot(rec, ap, 'Color', c(6,:), 'LineWidth', 2);

leg = legend(hs, str, 'Location', 'southwest');
leg.ItemTokenSize = [16 18];
savefig('mAP_eval_r', 'png');


% f2 = figure; hold on; xlabel('Recall'); ylabel('Precision'); grid on;
% plot(rec, ap, 'Color', 'b', 'LineWidth', 4);
% title(sprintf('mean average precision = %.2f%%',map*100));
% savefig('mAP_ssd300_coral_all', f2, 'png');