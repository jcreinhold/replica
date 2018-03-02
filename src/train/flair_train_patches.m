function [atlas_patches, atlas_Y] = flair_train_patches(as, ps, i)
%FLAIR_TRAIN_PATCHES get patches for training flair synth
%
%   Args:
%       as: atlas struct
%       ps: A struct containing the parameters for training.
%       i: iteration number
%
%   Output:
%       atlas_patches:
%       atlas_Y:

    % open all atlas images and lesion masks
    [atlas_t1w, ~] = open_atlas(as.t1w{i}, ps, true);
    [atlas_t2w, ~] = open_atlas(as.t2w{i}, ps, false);
    [atlas_pdw, ~] = open_atlas(as.pdw{i}, ps, false);
    atlas_lm = open_lesionmask(as.lesionmask{i}, ps);

    % set the FLAIR image as the target
    atlas_tgt = open_atlas(as.flair{i}, ps, false);

    % put atlas images in ordered cell for organized processing
    atlases = {atlas_t1w, atlas_t2w, atlas_pdw};
    
    % pull out the patches to be used in training given the atlases
    [atlas_patches, atlas_Y] = get_train_patches(atlas_tgt, atlases, ...
                                                 ps, atlas_lm);
end

