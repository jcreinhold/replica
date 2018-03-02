function [outputArg1,outputArg2] = get_all_patches(atlases, ps)
%GET_ALL_PATCHES Summary of this function goes here
%   Detailed explanation goes here
    atlas_t1w = atlases(1);
    if ps.synthFLAIR == 1
        lm = atlases(end);
        [I, J, K, orig, n_train] = determine_training_samples(atlas_t1w, ...
                                                              ps, lm);
    else
        [I, J, K, orig, n_train] = determine_training_samples(atlas_t1w, ps);
    end
    
    if ps.use_context_patch == 0
        atlas_patches = zeros(3*L, n_train);
        atlas_Y = zeros(1, n_train);   
    elseif ps.use_context_patch == 1
        atlas_patches = zeros(3*L+32, n_train);
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

