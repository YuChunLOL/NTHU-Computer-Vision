%% Clear all the histories
clc;clear;close all;

%% Constant for control
% if QUICK_DEMO == 1(true), load results from mat file instead of computing
% else, compute result again.
QUICK_DEMO = 1;

%% Perform Part 1-B
% The hsvMap will mapping value 0 ~ 1 to custom color space
hsvMap = linspace( 0, 1, 99 )' ;
hsvMap(:, 2) = 0.5;
hsvMap(:, 3) = 1;
rgbMap = hsv2rgb(hsvMap);
rgbMap = [ 0.2 0.2 0.2 ; rgbMap ];

if QUICK_DEMO == 1
    % load part 1-A result
    load('part_1b_result');
else
    % load part 1-A result
    load('part_1a_result');
    % convert images to grayscale
    Ig1 = rgb2gray(Ig1);
    Ig2 = rgb2gray(Ig2);
    % normalize images to [0-255] to [0-1]
    Ig1 = im2double(Ig1);
    Ig2 = im2double(Ig2);
    % compute magnitude and direction of gradient of image
    [grad_mag1, grad_dir1] = CornerDetection.imgradient(Ig1);
    [grad_mag2, grad_dir2] = CornerDetection.imgradient(Ig2);
    % filter weak gradients
    threshold = 0.1;
    grad_dir1(grad_mag1 < threshold) = 0;
    grad_dir2(grad_mag2 < threshold) = 0;
    % save results to 'part_1b_result.mat'
    save('part_1b_result', 'grad_mag1');
    save('part_1b_result', 'grad_mag2', '-append');
    save('part_1b_result', 'grad_dir1', '-append');
    save('part_1b_result', 'grad_dir2', '-append');
end

% show figures
figure('Name', 'Part 1-B Magnitude');
subplot(121), imshow(grad_mag1), title('Gradient of magnitude (gaussian kernel=10, sigma=5)');
subplot(122), imshow(grad_mag2), title('Gradient of magnitude (gaussian kernel=20, sigma=5)');
figure('Name', 'Part 1-B Direction');
subplot(121), imshow(grad_dir1,'ColorMap',rgbMap), title('Gradient of direction (gaussian kernel=10, sigma=5)');
subplot(122), imshow(grad_dir2,'ColorMap',rgbMap), title('Gradient of direction (gaussian kernel=20, sigma=5)');