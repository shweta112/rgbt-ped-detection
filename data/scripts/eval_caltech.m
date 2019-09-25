pLoad={'lbls',{'person'},'ilbls',{'people','person?','cyclist'}};
pLoadSq={'lbls',{'person'},'ilbls',{'people','person?','cyclist'},'squarify',{3,.41}};
pLoadReasonable = [pLoad, 'hRng',[45 inf], 'vRng',[0 0]];

[gt, dt] = bbGt('loadAll', ...
    '/media/shweta.mahajan/Daten/Human_Detection/Datasets/CaltechPedestrians/Caltech_new_annotations/anno_test_1xnew/', ...
    '/media/shweta.mahajan/Daten/Human_Detection/Datasets/CaltechPedestrians/faster-rcnn_resnet101_50p/caltech/', ...
    pLoadReasonable);
[gt, dt] = bbGt('evalRes', gt, dt);

[fp,tp,score,miss] = bbGt('compRoc',gt,dt,1,10.^(-2:.25:0));
miss=exp(mean(log(max(1e-10,1-miss)))); roc=[score fp tp];

f = figure; plotRoc([fp tp],'logx',1,'logy',1,'xLbl','fppi',...
  'lims',[3.1e-3 1e1 .05 1],'color','g','smooth',1,'fpTarget',10.^(-2:.25:0));
title(sprintf('log-average miss rate = %.2f%%',miss*100));
savefig('Roc_caltech_r', f, 'png');