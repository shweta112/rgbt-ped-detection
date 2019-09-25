inDir = '/media/shweta.mahajan/Daten/GitHub/rgbt-ped-detection/data/kaist-rgbt/videos/';
outDir = '/media/shweta.mahajan/Daten/GitHub/rgbt-ped-detection/data/kaist-rgbt/images/';

% Get a list of all files and folders in this folder.
destDirs = dir(strcat(inDir, 'set*'));

% Iterate over sets
for dirInd = 1:length(destDirs)
    destDir = destDirs(dirInd).name; % set00, ..
%     if ~strcmp(destDir, 'set04') && ~strcmp(destDir, 'set06')
%         continue
%     end
    
    disp(destDir)
    % Find sequence files
    fNames = dir(strcat(inDir, destDir, '/', '*.seq')); 
    
    % Iterate over files in destDir
    for fInd = 1:length(fNames)
        % Name of currest .seq file
        fName = fNames(fInd).name;
        disp(fName)
        % Innermost dest folder name
        folder = extractBefore(fName, '.seq');
        Is = seqIo(strcat(inDir, destDir, '/', fName), 'toImgs', strcat(outDir, destDir, '/', folder));
    end
end
