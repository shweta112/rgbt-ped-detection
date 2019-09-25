%% Load and save as mat
gtDir = '/media/shweta.mahajan/Transcend2TB/rgbt-ped-detection/data/kaist-rgbt/annotations_KAIST_test_set/';
dtMSDS = '/media/shweta.mahajan/Transcend2TB/MSDS-RCNN/detections/MSDS/det-test-all.txt';
% dtDirCoral = '/media/shweta.mahajan/Transcend2TB/rgbt/ssd_mobilenet2_coral/';

pLoad={'lbls',{'person'},'ilbls',{'people','person?','cyclist'}};
% pLoadReasonable = [pLoad, 'hRng',[51 inf],...
%     'vRng',[1 1],'xRng',[5 635],'yRng',[5 475]];

pLoadReasonable = [pLoad, 'hRng',[51 inf],...
    'vRng',[1 1]];

[gt0, dt0] = bbGt('loadAll', gtDir, dtMSDS, pLoadReasonable);
% save('dt_MSDS.mat', 'dt0');

[gt1, dt1] = bbGt('loadAll', gtDir, dtMSDS, pLoad);

g = cellfun(@isequal, gt0, gt1)

d = cellfun(@isequal, dt0, dt1)