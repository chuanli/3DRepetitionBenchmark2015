function [numBox, precision] = readpr(filename, resolution_pr_curve)

numBox = 0;
precision = zeros(1, resolution_pr_curve);

fid = fopen(filename);
% skip the first two lines
tline = fgets(fid);
tline = fgets(fid);

tline = fgets(fid);
numBox = str2num(tline);
for i_line = 1:resolution_pr_curve
    tline = fgets(fid);
    C = textscan(tline,'%f');
    precision(1, i_line) = C{1, 1}(2);
end

fclose(fid);