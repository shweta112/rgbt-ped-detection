%% Load and save as mat
gtDir = '/media/shweta.mahajan/Transcend2TB/rgbt-ped-detection/data/kaist-rgbt/annotations_KAIST_test_set/';
dtDirFrcnn = '/media/shweta.mahajan/Transcend/rgbt/faster-rcnn_50p_3ar_300k/';
dtDirSSD = '/media/shweta.mahajan/Transcend/rgbt/ssd-mobilenet-200k/';
dtMSDS = '/media/shweta.mahajan/Transcend2TB/MSDS-RCNN/detections/MSDS/det-test-all.txt';
% dtDirCoral = '/media/shweta.mahajan/Transcend2TB/rgbt/ssd_mobilenet2_coral/';

pLoad={'lbls',{'person'},'ilbls',{'people','person?','cyclist'}};
% pLoadReasonable = [pLoad, 'hRng',[51 inf],...
%     'vRng',[1 1],'xRng',[5 635],'yRng',[5 475]];

pLoadReasonable = [pLoad, 'hRng',[50 inf],...
    'vRng',[1 1]];

[~, dt0] = bbGt('loadAll', gtDir, dtDirFrcnn, pLoadReasonable);
save('dt_FRCNN.mat', 'dt0');

[~, dt0] = bbGt('loadAll', gtDir, dtDirSSD, pLoadReasonable);
save('dt_SSD.mat', 'dt0');

[gt0, dt0] = bbGt('loadAll', gtDir, dtMSDS, pLoadReasonable);
save('dt_MSDS.mat', 'dt0');

[gta, ~] = bbGt('loadAll', gtDir, dtDirFrcnn, pLoad);
save('gta.mat', 'gta');

