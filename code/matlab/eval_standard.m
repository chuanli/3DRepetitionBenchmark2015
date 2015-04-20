close all; clear all; clc;
path_data = 'C:\Chuan\3DRepetitionBenchmark2015\data\IQmulus_TerraMobilita\';
name_method = 'rigid';
pressure = 0.00 * 1000;
resolution_pr_curve = 100;


% DONOT CHANGE AFTER THIS LINE ----------------------------------------

files = dir( fullfile(path_data));
mask = ones(1, size(files, 1));
for i_file = 1:size(files, 1)
    if(isdir(files(i_file, 1).name))
        mask(1, i_file) = 0;
    end
end
files = files(logical(mask));


recall = [0:1/(resolution_pr_curve - 1):1];
num_file = size(files, 1);

% evalute all detection in path_detection, using standard pressure
precision_rigid = zeros(num_file, resolution_pr_curve);
numBox_rigid = zeros(num_file, 1);
for i_file = 1:size(files, 1)
    name = files(i_file, 1).name;
    path_pr_rigid = [path_data name '\'  'pr_rigid\'];
    % check if pr file exist
    filename_pr_rigid = [path_pr_rigid name '_rigid_' name_method '_' num2str(pressure) '.pr'];
    if exist(filename_pr_rigid, 'file')
        [numBox_rigid(i_file), precision_rigid(i_file, :)] = readpr(filename_pr_rigid, resolution_pr_curve);
    else
        numBox_rigid(i_file) = 0;
        precision_rigid(i_file, :) = zeros(1, resolution_pr_curve);
    end
end
average_precision_rigid = sum(precision_rigid .* repmat(numBox_rigid, 1, resolution_pr_curve), 1)/sum(numBox_rigid);

% evalute all detection in path_detection, using standard pressure
precision_semantic = zeros(num_file, resolution_pr_curve);
numBox_semantic = zeros(num_file, 1);
for i_file = 1:size(files, 1)
    name = files(i_file, 1).name;
    path_pr_semantic = [path_data name '\'  'pr_semantic\'];
    % check if pr file exist
    filename_pr_semantic = [path_pr_semantic name '_semantic_' name_method '_' num2str(pressure) '.pr'];
    if exist(filename_pr_semantic, 'file')
        [numBox_semantic(i_file), precision_semantic(i_file, :)] = readpr(filename_pr_semantic, resolution_pr_curve);
    else
        numBox_semantic(i_file) = 0;
        precision_semantic(i_file, :) = zeros(1, resolution_pr_curve);
    end
end
average_precision_semantic = sum(precision_semantic .* repmat(numBox_semantic, 1, resolution_pr_curve), 1)/sum(numBox_semantic);

% render
h1 = figure;
set(h1, 'Color',[255, 255, 255]/255, 'name', 'pr rigid, method rigid');
axis equal;
axis([0 1 0 1]);
xlabel('Recall');
ylabel('Precision');
grid on;
set(gca,'XTick',0:0.1:1);
set(gca,'YTick',0:0.1:1);
hold on;
plot(recall, average_precision_rigid, 'r-', 'LineWidth', 4);

h2 = figure;
set(h2, 'Color',[255, 255, 255]/255, 'name', 'pr semantic, method rigid');
axis equal;
axis([0 1 0 1]);
xlabel('Recall');
ylabel('Precision');
grid on;
set(gca,'XTick',0:0.1:1);
set(gca,'YTick',0:0.1:1);
hold on;
plot(recall, average_precision_semantic, 'r-', 'LineWidth', 4);

return;

