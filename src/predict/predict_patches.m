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
    
    if isfield(ss, 't1w') && ps.target ~= 't1w'
        [subject_images{end+1}, dim] = open_atlas(ss.t1w, ps, true);
    else
        error('REPLICA requires a T1w image for training/predicition');
    end
    if isfield(ss, 't2w') && ps.target ~= 't2w'
        [subject_images{end+1}, ~] = open_atlas(ss.t2w, ps, false);
    end
    if isfield(ss, 'pdw') && ps.target ~= 'pdw'
        [subject_images{end+1}, ~] = open_atlas(ss.pdw, ps, false);
    end
    if isfield(ss, 'flair') && ps.target ~= 'flair'
        [subject_images{end+1}, ~] = open_atlas(ss.flair, ps, false);
    end
    
    % pull out the patches to be used in prediction
    [test_patches, fg] = get_predict_patches(subject_images, ps);
end

