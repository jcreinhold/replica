function [I, J, K, orig, n] = get_train_params(atlas_t1w, atlas_tgt, ps, lm)
%GET_TRAIN_PARAMS
%
%   Args:
%       atlas_t1w: T1-weighted atlas image
%       atlas_tgt: target atlas image
%       ps: A struct containing the parameters for training.
%       lm: lesion mask
%
%   Output:
%       I:
%       J:
%       K:
%       orig:
%       n: number of training samples

    % assumes that the background = 0 and tissue intensities are  > 0
    src_fg = atlas_t1w(atlas_t1w > 0);

    yq = quantile(src_fg, 100);
    yq = [0, yq];
    no_quantile_voxels = ps.n_training_samples_per_brain / 100;
    all_training_idxs = [];
    for qiter = 2:length(yq)
        curr_idxs = find(atlas_t1w > yq(qiter-1) & ...
                         atlas_t1w <= yq(qiter) & ...
                         atlas_tgt > ps.threshold);
        if isempty(curr_idxs)
            continue;
        end
        indices_idxs = randi(length(curr_idxs), no_quantile_voxels, 1);
        all_training_idxs = [all_training_idxs; curr_idxs(indices_idxs)];
    end
    curr_idxs = find(atlas_t1w > yq(qiter) & ...
                     atlas_t1w <= max(atlas_t1w(:)) & ...
                     atlas_tgt > ps.threshold);
    indices_idxs = randi(length(curr_idxs), no_quantile_voxels, 1);
    all_training_idxs = [all_training_idxs; curr_idxs(indices_idxs)];
    
    if nargin > 3
        lesion_idxs = find(lm == 1);
        all_training_idxs = [all_training_idxs; lesion_idxs];
    end
    
    [I, J, K] = ind2sub(size(atlas_t1w), all_training_idxs);
    orig = floor(size(atlas_t1w)/2);
    n = length(all_training_idxs);
end

