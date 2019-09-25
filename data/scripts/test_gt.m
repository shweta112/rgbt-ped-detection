gt0 = load('/media/shweta.mahajan/Daten/gt0.mat');
gt0 = gt0.gt0;

gta = load('/media/shweta.mahajan/Daten/gta.mat');
gta = gta.gta;

% gt = load('/media/shweta.mahajan/Transcend2TB/illumination-aware_multispectral_pedestrian_detection/gt-Reasonable.mat');
% gt = gt.gt;

cellfun(@isequal, gt0, gta)