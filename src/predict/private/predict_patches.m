function [test_patches, dim, fg] = predict_patches(ss, ps)
%FLAIR_PREDICT_PATCHES extract patches to do regression on w/ RF
% specific to synthesizing target images from T1w, T2w, PDw, FLAIR images
%
%   Args:
%       ss: subject_struct, contains filenames of subjects
%       ps: A struct containing the parameters for synthesis.
%
%   Output:
%       test_patches: patches on which to do regression (from ss)
%       dim: dimension of synthesized image (for saving result image)
%       fg: foreground indices (for saving result image)

    % open all subject images and
    % put subject images in ordered cell for organized processing
    subject_images = {};
    
    if isfield(ss, 't1w') && ~strcmp(ps.target, 't1w')
        [subject_images{end+1}, dim] = open_atlas(ss.t1w, ps.w4, ps.r4, true);
    else
        error('REPLICA requires a T1w image for training/predicition');
    end
    if isfield(ss, 't2w') && ~strcmp(ps.target, 't2w')
        [subject_images{end+1}, ~] = open_atlas(ss.t2w, ps.w4, ps.r4, false);
    end
    if isfield(ss, 'pdw') && ~strcmp(ps.target, 'pdw')
        [subject_images{end+1}, ~] = open_atlas(ss.pdw, ps.w4, ps.r4, false);
    end
    if isfield(ss, 'flair') && ~strcmp(ps.target, 'flair')
        [subject_images{end+1}, ~] = open_atlas(ss.flair, ps.w4, ps.r4, false);
    end
    
    % pull out the patches to be used in prediction
    [test_patches, fg] = get_predict_patches(subject_images, ps);
end

function [test_patches, fg] = get_predict_patches(subject_images, ps)
%GET_PREDICT_PATCHES 
%
%   Args:
%       subject_images: cell array of all subject contrasts
%       ps: Has the parameter set with which REPLICA was trained
%
%   Output:
%       test_patches: patches to do regression on
%       fg: foreground indices, for saving synthesized image

    subject_t1w = subject_images{1};  % T1w-image will always be first element
    
    patch_size = ps.patch_size;
    L = patch_size(1) * patch_size(2) * patch_size(3);
    
    patch_size_multiplier = length(subject_images);
    
    [I, J, K, orig, n, fg] = get_predict_params(subject_t1w, ps);

    if ps.use_context_patch == 0
        test_patches = zeros(patch_size_multiplier*L, n);     
    elseif ps.use_context_patch == 1
        test_patches = zeros(patch_size_multiplier*L+32, n);
    else
        error('param_struct.use_context_patch needs to be 0 or 1');
    end
    
    parfor viter = 1:n
        i = I(viter);
        j = J(viter);
        k = K(viter);
        patches = get_patch(subject_images, i, j, k, orig, L, ps);
        test_patches(:, viter) = patches;
    end
end

function [I, J, K, orig, n, fg] = get_predict_params(subject_t1w, ps)
%GET_PREDICT_PARAMS Summary of this function goes here
%
%   Args:
%       subject_t1w:
%
%   Output:
%       I:
%       J:
%       K:
%       orig:
%       n:
%       fg: foreground indices (for saving result image)

    dim = size(subject_t1w);
    fg = find(subject_t1w > ps.threshold);
    [I, J, K] = ind2sub(dim, fg);
    orig = floor(dim/2);
    n = length(fg);
end
