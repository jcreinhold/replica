function [atlas_patches, atlas_Y] = t2_train_patches(as, ps, i)
%T2_TRAIN_PATCHES Summary of this function goes here
%
%   Args:
%       as: atlas struct containing filenames for atlas
%       ps: A struct containing the parameters for training.
%       i: iteration number
%
%   Output:
%       atlas_patches:
%       atlas_Y:

    % open all atlas images and lesion masks
    [atlas_t1w, ~] = open_atlas(as.t1w{i}, ps, true);
    
    % set the T2w image as the target
    atlas_tgt = open_atlas(as.t2w{i}, ps, false);
    
    % put atlas images in ordered array for organized processing
    atlases = {atlas_t1w};
    
    % pull out the patches to be used in training given the atlases
    [atlas_patches, atlas_Y] = get_train_patches(atlas_tgt, atlases, ps); 
end

