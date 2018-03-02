function [atlas_patches, atlas_Y] = t2_train_patches(t1_fn, t2_fn, ps)
%T2_TRAIN_PATCHES Summary of this function goes here
%
%   Args:
%       t1_fn: full filename of T1w atlas image
%       t2_fn: full filename of T2w atlas image
%       ps: A struct containing the parameters for training.
%
%   Output:
%       atlas_patches:
%       atlas_Y:

    % open all atlas images and lesion masks
    atlas_t1w = open_atlas(t1_fn, ps, true);clo
    
    % set the T2w image as the target
    atlas_tgt = open_atlas(t2_fn, ps, false);
    
    % put atlas images in ordered array for organized processing
    atlases = {atlas_t1w};
    
    % pull out the patches to be used in training given the atlases
    [atlas_patches, atlas_Y] = get_train_patches(atlas_tgt, atlases, ps); 
end

