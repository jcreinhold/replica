function [atlas_patches, atlas_Y] = train_patches(as, ps, i)
%TRAIN_PATCHES get patches for training REPLICA random forest
% for target images using all images provided by user
%
%   Args:
%       as: atlas struct
%       ps: A struct containing the parameters for training.
%       i: iteration number
%
%   Output:
%       atlas_patches:
%       atlas_Y:

    % open target contrast images
    target_fns = as.(ps.target);
    target = open_atlas(target_fns{i}, ps.w4, ps.r4, false);
    
    % open all atlas images and lesion masks and
    % put atlas images in ordered cell for organized processing
    atlases = {};
    
    if isfield(as, 't1w') && ~strcmp(ps.target, 't1w')
        [atlases{end+1}, ~] = open_atlas(as.t1w{i}, ps.w4, ps.r4, true);
    else
        error('REPLICA requires a T1w image for training/predicition');
    end
    if isfield(as, 't2w') && ~strcmp(ps.target, 't2w')
        [atlases{end+1}, ~] = open_atlas(as.t2w{i}, ps.w4, ps.r4, false);
    end
    if isfield(as, 'pdw') && ~strcmp(ps.target, 'pdw')
        [atlases{end+1}, ~] = open_atlas(as.pdw{i}, ps.w4, ps.r4, false);
    end
    if isfield(as, 'flair') && ~strcmp(ps.target, 'flair')
        [atlases{end+1}, ~] = open_atlas(as.pdw{i}, ps.w4, ps.r4, false);
    end
    if isfield(as, 'lesionmask')
        lm = open_lesionmask(as.lesionmask{i}, ps);
    end
    
    % pull out the patches to be used in training given the atlases
    if isfield(as, 'lesionmask')
        [atlas_patches, atlas_Y] = get_train_patches(target, atlases, ps, ...
                                                     'LesionMask', lm);
    else
        [atlas_patches, atlas_Y] = get_train_patches(target, atlases, ps);
    end
end

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
    L = prod(ps.patch_size);
    
    atlas_num = length(atlases);
    
    if opts.LesionMask
        [I, J, K, orig, n] = get_train_params(atlas_t1w, target, ps, lm);
    else
        [I, J, K, orig, n] = get_train_params(atlas_t1w, target, ps);
    end
    
    if ps.use_context_patch == 0
        atlas_patches = zeros(atlas_num*L, n);     
    elseif ps.use_context_patch == 1
        atlas_patches = zeros(atlas_num*L+32, n);
    else
        error('param_struct.use_context_patch needs to be 0 or 1');
    end
    atlas_Y = zeros(1,n);
    
    parfor viter = 1:n
        i = I(viter);
        j = J(viter);
        k = K(viter);
        patches = get_patch(atlases, i, j, k, orig, L, ps);
        atlas_patches(:, viter) = patches;
    end
    
    % this is broken into it's own loop for better parallel performance
    % and it has to be written like this because I,J,K too large
    for viter = 1:n
        i = I(viter);
        j = J(viter);
        k = K(viter);
        atlas_Y(viter) = target(i, j, k);
    end
end