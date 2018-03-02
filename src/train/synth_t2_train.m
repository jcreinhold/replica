function [atlas_patches, atlas_Y] = synth_t2_train(t1_fn, t2_fn, ps)
%SYNTH_T2_TRAIN Summary of this function goes here
%
%   Args:
%       t1_fn: full filename of T1w atlas image
%       t2_fn: full filename of T2w atlas image
%       ps: A struct containing the parameters for training.
%
%   Output:
%       

    atlas_t1w = open_atlas(t1_fn);
    atlas_t2w = open_atlas(t2_fn);

    atlas_trg = atlas_t2w;
    atlases = [atlas_t1w];
    
    [I, J, K, orig, n_train] = determine_training_samples(atlas_t1w, ps);
    
    if ps.use_context_patch == 0
        atlas_patches = zeros(L, n_train);
        atlas_Y = zeros(1, n_train);   
    elseif ps.use_context_patch == 1
        atlas_patches = zeros(L+32, n_train);
        atlas_Y = zeros(1, n_train);
    end
    
    for viter = 1:n_train
        i = I(viter);
        j = J(viter);
        k = K(viter);
        patches = get_patch(atlases, i, j, k, orig, ps);
        atlas_patches(:, viter) = patches;
        atlas_Y(viter) = atlas_trg(i, j, k);
    end
    
end

