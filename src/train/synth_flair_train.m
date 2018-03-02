function [atlas_patches, atlas_Y] = synth_flair_train(t1_fn, t2_fn, pd_fn, ...
                                                    fl_fn, lm_fn, ps)
%SYNTH_FLAIR_TRAIN get patches for training flair synth
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
%       

    % Size of patch in the original highest resolution
    patch_size = ps.patch_size;
    L = patch_size(1) * patch_size(2) * patch_size(3);

    atlas_t1w = open_atlas(t1_fn, ps);
    atlas_t2w = open_atlas(t2_fn, ps);
    atlas_pdw = open_atlas(pd_fn, ps);
    atlas_flair = open_atlas(fl_fn, ps);
    atlas_lesionmask = open_lesionmask(lm_fn, ps);

    atlas_trg = atlas_flair;

    atlases = [atlas_t1w, atlas_t2w, atlas_pdw];
    
    [atlas_patches, atlas_Y] = get_all_patches(atlases);
end

