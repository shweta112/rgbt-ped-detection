%% Input parameters
gtDir = '/media/shweta.mahajan/Transcend2TB/fraunhofer_dataset/test/annotations/cropped/';
dtDir = '/media/shweta.mahajan/Transcend2TB/rgbt-ped-detection/data/kaist-rgbt/inference/rgbt/ssd_mobilenet2_coral_ft/';
pLoad={'lbls',{'person'},'ilbls',{'people','person?','cyclist'}};
pLoadReasonable = [pLoad, 'hRng',[45 inf],...
    'vRng',[1 1],'xRng',[5 635],'yRng',[5 475]];

%% Load the bbs and evaluate
[gt0, dt0] = bbGt('loadAll', gtDir, dtDir, pLoad);
save('gt0_Fraunhofer.mat', 'gt0');
[gt, dt] = bbGt('evalRes', gt0, dt0);

%% Calculate metrics and visualize graph
[fp,tp,score,miss] = bbGt('compRoc',gt,dt,1,10.^(-2:.25:0));
rec = (0:.1:1);
[fp1,tp1,score1,ap] = bbGt('compRoc',gt,dt,0,rec);
miss=exp(mean(log(max(1e-10,1-miss))));
map = sum(ap)/length(ap);

f1 = figure; plotRoc([fp tp],'logx',1,'logy',1,'xLbl','FPPI', 'yLbl', 'Miss rate',...
  'lims',[2e-4 1 0 1],'color','b','smooth',1,'fpTarget',10.^(-2:.25:0),'lineWd', 2);
title(sprintf('log-average miss rate = %.2f%%',miss*100));
yticks = get(gca,'YTick')
set(gca,'YTickLabel',yticks);
% savefig('Roc_coral_ft', f1, 'png');

% f2 = figure; plotRoc([(0:.1:1) map],'logx',0,'logy',0,'xLbl','Recall', 'yLbl', 'Precision',...
%   'color','b','smooth',1);
f2 = figure; hold on; xlabel('Recall'); ylabel('Precision'); grid on;
plot(rec, ap, 'Color', 'b', 'LineWidth', 2);
title(sprintf('mAP = %.2f%%',map*100));
% savefig('mAP_coral_ft', f2, 'png');