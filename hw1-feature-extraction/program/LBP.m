classdef LBP
    methods (Static)
        % compute LBP(dim=256) for image
        function lbp = computeLBP(image)
            [num_row, num_col] = size(image);
            % pad image with -Inf
            image_padded = padarray(image, [1,1], -inf);
            % compute lbp decimal values and save it to 2-D array (dec_val)
            lbp = zeros(num_row, num_col);
            for x = 2:size(image_padded, 1)-1
                for y = 2:size(image_padded, 2)-1
                    bin = [0, 0, 0, 0, 0, 0, 0, 0];
                    center = image_padded(x,y);
                    % perform lbp binary comparison, if neighbor pixel >= center pixel,
                    % then neighbor set to 1, else 0;
                    % start from top-left and perform in clockwise
                    if image_padded(x-1,y-1) >= center
                        bin(1) = 1;
                    end
                    % top-top
                    if image_padded(x-1,y) >= center
                        bin(2) = 1;
                    end
                    % top-right
                    if image_padded(x-1,y+1) >= center
                        bin(3) = 1;
                    end
                    % right-right
                    if image_padded(x,y+1) >= center
                        bin(4) = 1;
                    end
                    % bottom-right
                    if image_padded(x+1,y+1) >= center
                        bin(5) = 1;
                    end
                    % bottom-bottom
                    if image_padded(x+1,y) >= center
                        bin(6) = 1;
                    end
                    % bottom-left
                    if image_padded(x+1,y-1) >= center
                        bin(7) = 1;
                    end
                    % left-left
                    if image_padded(x,y-1) >= center
                        bin(8) = 1;
                    end
                    % convert binary to decimal number (LBP value)
                    power_of_2 = [128, 64, 32, 16, 8, 4, 2, 1];
                    lbp(x-1,y-1) = dot(bin, power_of_2);
                end
            end
        end

        % convert image to normalized histogram vector
        function [histogram_vector, normalized_histogram_vector] = image2NormalizedHistogramVector(image, dim)
            % compute every frequency of intensity (0 ~ dim-1) of image
            histogram_vector = zeros(1, dim);
            for intensity=0:dim-1
                histogram_vector(intensity+1) = sum(image(:) == intensity);
            end
            normalized_histogram_vector = histogram_vector / norm(histogram_vector);
        end

        % split image to (split_num x split_num), then compute LBP
        % histogram vector for every splitted image,
        % then concatenate all LBP histogram vectors to one
        % normalized histogram vector
        function [histogram_vector, normalized_histogram_vector] = image2ConcatedNormalizedHistogramVector(image, split_num, isUniform)
            [num_row, num_col] = size(image);
            split_row = num_row / split_num;
            split_col = num_col / split_num;
            % if we want to split 360x360 image to 2x2 image
            % split_row = 360/2 = 180 = split_col
            % num_row_splits = [1, 1] * 180 = [180, 180] = num_col_splits
            num_row_splits = ones(1, split_num) * (split_row);
            num_col_splits = ones(1, split_num) * (split_col);
            % split image to (split_num x split_num) cell
            cell = mat2cell(image, num_row_splits, num_col_splits);
            [num_row, num_col] = size(cell);
            histogram_vector = [];
            % for every image in cell
            for x=1:num_row
                for y=1:num_col
                    image = cell{x,y};
                    % compute LBP for every image
                    imageLBP = LBP.computeLBP(image);
                    % compute LBP or uniform LBP histogram vector
                    if isUniform == 0
                        [hv, nhv] = LBP.image2NormalizedHistogramVector(imageLBP, 256);
                    else
                        imageUniformLBP = LBP.LBP2UniformLBP(imageLBP);
                        [hv, nhv] = LBP.image2NormalizedHistogramVector(imageUniformLBP, 59);
                    end
                    % append current image histogram vector to result histogram vector
                    histogram_vector = [histogram_vector, hv];
                end
            end
            % normalize result histogram vector
            normalized_histogram_vector = histogram_vector / norm(histogram_vector);
        end

        % convert LBP(dim=256) to uniform LBP(dim=59)
        function uniform_lbp = LBP2UniformLBP(lbp)
            % 58 different kind of uniform binary to decimal cases.
            uniform_lookup_table = [0,1,2,3,4,6,7,8,12,14,15,16,...
                24,28,30,31,32,48,56,60,62,63,64,96,...
                112,120,124,126,127,128,129,131,135,...
                143,159,191,192,193,195,199,207,223,...
                224,225,227,231,239,240,241,243,247,...
                248,249,251,253,253,254,255];
            % map every value in lbp matrix to uniform lookup table index
            [num_row, num_col] = size(lbp);
            uniform_lbp = zeros(num_row, num_col);
            for x=1:num_row
                for y=1:num_col
                    [is_exist, index] = ismember(lbp(x,y), uniform_lookup_table);
                    if is_exist
                        uniform_lbp(x,y) = index - 1;
                    else
                        uniform_lbp(x,y) = 58;
                    end
                end
            end
        end
    end
end
