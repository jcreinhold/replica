function [atlas_patches, atlas_Y] = get_train_patches(target, atlases, ps, varargin)
%GET_TRAIN_PATCHES gets patches for REPLICA training
%
%   Args:
%       atlases: 
%       ps: A struct containing the parameters for training.
%
%   Output:
%       atlas_patches:
%       atlas_Y:

    % parse arguments to account for optional args
    p = inputParser;
    p.addOptional('LesionMask', false);
    p.parse(varargin{:})
    opts = p.Results;
    
    atlas_t1w = atlases{1};  % T1w-image will always be first element
    
    patch_size = ps.patch_size;
    L = patch_size(1) * patch_size(2) * patch_size(3);
    
    patch_size_multiplier = length(atlases);
    
    if opts.LesionMask
        [I, J, K, orig, n] = get_train_params(atlas_t1w, target, ps, lm);
    else
        [I, J, K, orig, n] = get_train_params(atlas_t1w, target, ps);
    end
    
    if ps.use_context_patch == 0
        atlas_patches = zeros(patch_size_multiplier*L, n);     
    elseif ps.use_context_patch == 1
        atlas_patches = zeros(patch_size_multiplier*L+32, n);
    else
        error('param_struct.use_context_patch needs to be 0 or 1');
    end
    atlas_Y = zeros(1, n);
    
    for viter = 1:n
        i = I(viter);
        j = J(viter);
        k = K(viter);
        patches = get_patch(atlases, i, j, k, orig, L, ps);
        atlas_patches(:, viter) = patches;
        atlas_Y(viter) = target(i, j, k);
    end
end

