%% Clear all the histories
clc;clear;close all;

%% Constant for control
% if QUICK_DEMO == 1(true), load results from mat file instead of computing
% else, compute result again.

% 因為本程式的結果存成 .mat 會很大, 所以請先耐心跑完...
% 等到第一次跑完生成 "part_1e_result.mat" 時，可將此改成 1，以便快速顯示結
QUICK_DEMO = 0;

%% Perform Part 1-C
% read image and convert it to grayscale
I = imread('J4Poro.png');
I = rgb2gray(I);
% normalize image to [0-255] to [0-1]
I = im2double(I);

if QUICK_DEMO == 1
    load('part_1c_result');
else
    % load gradient magnitudes from part 1-B result
    load('part_1b_result');
    % detect corners for 2 gradient magnitudes from part 1-B and 2 different window size (here are 4 results)
    Ieig1 = CornerDetection.detectCorner(grad_mag1, 3);
    Ieig2 = CornerDetection.detectCorner(grad_mag1, 5);
    Ieig3 = CornerDetection.detectCorner(grad_mag2, 3);
    Ieig4 = CornerDetection.detectCorner(grad_mag2, 5);
    % compute largest eigenvalue for every Ieigs, 
    % then multiply a constant as their threshold value for corner detection respectivley.
    threshold1 = 0.05 * max(max(Ieig1));
    threshold2 = 0.05 * max(max(Ieig2));
    threshold3 = 0.05 * max(max(Ieig3));
    threshold4 = 0.05 * max(max(Ieig4));
    % save results to 'part_1c_result.mat' file
    save('part_1c_result', 'Ieig1');
    save('part_1c_result', 'Ieig2', '-append');
    save('part_1c_result', 'Ieig3', '-append');
    save('part_1c_result', 'Ieig4', '-append');
    save('part_1c_result', 'threshold1', '-append');
    save('part_1c_result', 'threshold2', '-append');
    save('part_1c_result', 'threshold3', '-append');
    save('part_1c_result', 'threshold4', '-append');
end
% pick a smallest threshold for following comparison
threshold = min([threshold1, threshold2, threshold3, threshold4]);
% plot corner positions on original image (here are 4 results)
% for gaussian kernel size=10, sigma=5, tensor structure window size=3
[posc1, posr1] = find(Ieig1 > threshold);
figure('Name', 'Corners without NMS (grad_mag1, 3x3 window)'), imshow(I);
hold on;
plot(posr1, posc1, 'r.');
% for gaussian kernel size=10, sigma=5, tensor structure window size=5
[posc2, posr2] = find(Ieig2 > threshold);
figure('Name', 'Corners without NMS (grad_mag1, 5x5 window)'), imshow(I);
hold on;
plot(posr2, posc2, 'r.');
% for gaussian kernel size=20, sigma=5, tensor structure window size=3
[posc3, posr3] = find(Ieig3 > threshold);
figure('Name', 'Corners without NMS (grad_mag2, 3x3 window)'), imshow(I);
hold on;
plot(posr3, posc3, 'r.');
% for gaussian kernel size=20, sigma=5, tensor structure window size=5
[posc4, posr4] = find(Ieig4 > threshold);
figure('Name', 'Corners without NMS (grad_mag2, 5x5 window)'), imshow(I);
hold on;
plot(posr4, posc4, 'r.');