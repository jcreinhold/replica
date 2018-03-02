function [atlas_patches, atlas_Y] = flair_train_patches(t1_fn, t2_fn, pd_fn, ...
                                                        fl_fn, lm_fn, ps)
%FLAIR_TRAIN_PATCHES get patches for training flair synth
%
%   Args:
%       t1_fn: full filename of T1w atlas image
%       t2_fn: full filename of T2w atlas image
%       pd_fn: full filename of PDw atlas image
%       fl_fn: full filename of FLAIR atlas image
%       lm_fn: full filename of lesion mask
%       ps: A struct containing the parameters for training.
%
%   Output:
%       atlas_patches:
%       atlas_Y:

    % open all atlas images and lesion masks
    atlas_t1w = open_atlas(t1_fn, ps, true);
    atlas_t2w = open_atlas(t2_fn, ps, false);
    atlas_pdw = open_atlas(pd_fn, ps, false);
    atlas_lm = open_lesionmask(lm_fn, ps);

    % set the FLAIR image as the target
    atlas_tgt = open_atlas(fl_fn, ps, false);

    % put atlas images in ordered cell for organized processing
    atlases = {atlas_t1w, atlas_t2w, atlas_pdw};
    
    % pull out the patches to be used in training given the atlases
    [atlas_patches, atlas_Y] = get_train_patches(atlas_tgt, atlases, ...
                                                 ps, atlas_lm);
end

