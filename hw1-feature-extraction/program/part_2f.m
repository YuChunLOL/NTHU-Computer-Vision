%% Clear all the histories
clc;clear;close all;

%% Constant for control
% if QUICK_DEMO == 1(true), load results from mat file instead of computing
% else, compute result again.
QUICK_DEMO = 1;

%% Perform Part 2-F
if QUICK_DEMO == 1
    load('part_2f_result');
else
    % read images and convert them to grayscale
    kobe = rgb2gray(imread('kobeFace.png'));
    gasol = rgb2gray(imread('gasolFace.png'));
    % compare similarity for 2x2 case
    split_num = 2, isUniform = 1;
    [kobe_hv, kobe_nhv] = LBP.image2ConcatedNormalizedHistogramVector(kobe, split_num, isUniform);
    [gasol_hv, gasol_nhv] = LBP.image2ConcatedNormalizedHistogramVector(gasol, split_num, isUniform);
    similarity2x2 = dot(kobe_nhv, gasol_nhv);
    % compare similarity for 3x3 case
    split_num = 3, isUniform = 1;
    [kobe_hv, kobe_nhv] = LBP.image2ConcatedNormalizedHistogramVector(kobe, split_num, isUniform);
    [gasol_hv, gasol_nhv] = LBP.image2ConcatedNormalizedHistogramVector(gasol, split_num, isUniform);
    similarity3x3 = dot(kobe_nhv, gasol_nhv);
    % compare similarity for 4x4 case
    split_num = 4, isUniform = 1;
    [kobe_hv, kobe_nhv] = LBP.image2ConcatedNormalizedHistogramVector(kobe, split_num, isUniform);
    [gasol_hv, gasol_nhv] = LBP.image2ConcatedNormalizedHistogramVector(gasol, split_num, isUniform);
    similarity4x4 = dot(kobe_nhv, gasol_nhv);
    % compare similarity for 9x9 case
    split_num = 9, isUniform = 1;
    [kobe_hv, kobe_nhv] = LBP.image2ConcatedNormalizedHistogramVector(kobe, split_num, isUniform);
    [gasol_hv, gasol_nhv] = LBP.image2ConcatedNormalizedHistogramVector(gasol, split_num, isUniform);
    similarity9x9 = dot(kobe_nhv, gasol_nhv);
    % compare similarity for 20x20 case
    split_num = 20, isUniform = 1;
    [kobe_hv, kobe_nhv] = LBP.image2ConcatedNormalizedHistogramVector(kobe, split_num, isUniform);
    [gasol_hv, gasol_nhv] = LBP.image2ConcatedNormalizedHistogramVector(gasol, split_num, isUniform);
    similarity20x20 = dot(kobe_nhv, gasol_nhv);
    % save results to 'part_2c_result'
    save('part_2f_result', 'similarity2x2');
    save('part_2f_result', 'similarity3x3', '-append');
    save('part_2f_result', 'similarity4x4', '-append');
    save('part_2f_result', 'similarity9x9', '-append');
    save('part_2f_result', 'similarity20x20', '-append');
end
% show similarity in command window
disp(strcat('Similarity (2x2 case):', num2str(similarity2x2)));
disp(strcat('Similarity (3x3 case):', num2str(similarity3x3)));
disp(strcat('Similarity (4x4 case):', num2str(similarity4x4)));
disp(strcat('Similarity (9x9 case):', num2str(similarity9x9)));
disp(strcat('Similarity (20x20 case):', num2str(similarity20x20)));