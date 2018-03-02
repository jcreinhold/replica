function [test_patches, dim, fg] = flair_predict_patches(ss, ps)
%FLAIR_PREDICT_PATCHES extract patches to do regression on w/ RF
% specific to synthesizing FLAIR images from T1w, T2w, and PDw images
%
%   Args:
%       ss: subject_struct, contains filenames of subjects
%       ps: A struct containing the parameters for synthesis.
%
%   Output:
%       test_patches: patches on which to do regression (from ss)
%       dim: dimension of synthesized image (for saving result image)
%       fg: foreground indices (for saving result image)

    % open all subject images
    [subject_t1w, dim] = open_atlas(ss.t1w, ps, false);
    [subject_t2w, ~] = open_atlas(ss.t2w, ps, false);
    [subject_pdw, ~] = open_atlas(ss.pdw, ps, false);
    
    % put subject images in ordered cell for organized processing
    subject_images = {subject_t1w, subject_t2w, subject_pdw};
    
    % pull out the patches to be used in prediction
    [test_patches, fg] = get_predict_patches(subject_images, ps);
end

