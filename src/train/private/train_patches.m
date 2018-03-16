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
    target = open_atlas(target_fns{i}, ps, false);
    
    % open all atlas images and lesion masks and
    % put atlas images in ordered cell for organized processing
    atlases = {};
    
    if isfield(as, 't1w') && ~strcmp(ps.target, 't1w')
        [atlases{end+1}, ~] = open_atlas(as.t1w{i}, ps, true);
    else
        error('REPLICA requires a T1w image for training/predicition');
    end
    if isfield(as, 't2w') && ~strcmp(ps.target, 't2w')
        [atlases{end+1}, ~] = open_atlas(as.t2w{i}, ps, false);
    end
    if isfield(as, 'pdw') && ~strcmp(ps.target, 'pdw')
        [atlases{end+1}, ~] = open_atlas(as.pdw{i}, ps, false);
    end
    if isfield(as, 'flair') && ~strcmp(ps.target, 'flair')
        [atlases{end+1}, ~] = open_atlas(as.pdw{i}, ps, false);
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

