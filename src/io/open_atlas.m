function [atlas, dim, dim_orig, pad_vals] = open_atlas(fn, w, r, varargin)
%OPEN_ATLAS open an atlas image and preprocess it.
%
%   Args:
%       fn: filename, full path to nifti file to open
%       w: see [1] in context features
%       r: see [1] in context features
%
%   Output:
%       atlas: opened, normalized, and padded atlas
%       dim: dimension of the target image (used later for synthesis)
%       dim_orig: if resizing, save dimension of the image before resizing
%
%   References:
%   [1] A. Jog, et al., ``Random forest regression for magnetic resonance
%       image synthesis'', Medical Image Analysis, 35:475-488, 2017.

    % parse arguments to account for optional args
    p = inputParser;
    p.addParameter('BrainMask', '', @ischar);
    p.addParameter('WMPeakNormalize', true, @islogical);
    p.addParameter('isT1', false, @islogical);
    p.addParameter('fcmeans', false, @islogical);
    p.addParameter('T1wNormImg', [], @isnumeric);
    p.addParameter('train_img_dim', [], @isnumeric);
    p.parse(varargin{:})
    params = p.Results;
    
    tmp_atlas = load_untouch_nii(fn);
    tmp_atlas = double(tmp_atlas.img);
    if params.WMPeakNormalize
        threshold = 0.001 * median(tmp_atlas(:));
        if params.BrainMask
            mask_fn = params.BrainMask;
            mask = load_untouch_nii(mask_fn);
            brain = tmp_atlas .* double(mask.img);
            if ~isempty(params.T1wNormImg)
                params.T1wNormImg = params.T1wNormImg .* double(mask.img);
            end
        else
            brain = tmp_atlas;
        end
        if params.fcmeans
            if params.isT1
                [brain, scale_factor] = wm_peak_normalize_fcm(brain, threshold);
            elseif ~isempty(params.T1wNormImg)
                [brain, scale_factor] = wm_peak_normalize_fcm(brain, threshold, params.T1wNormImg);
            else
                error('for FCM, isT1 needs to be true or T1wNormImg needs to be provided');
            end
        else
            if params.isT1
                [brain, scale_factor] = wm_peak_normalize_T1w(brain, threshold);
            else
                [brain, scale_factor] = wm_peak_normalize_T2w(brain, threshold);
            end
        end
        if params.BrainMask
            tmp_atlas = scale_factor * tmp_atlas;
        else
            tmp_atlas = brain;
        end
    end
    if nargout > 2
        dim_orig = size(tmp_atlas); % get original dimension before padding
    end
    if nargout > 3
        pad_vals = [0 0 0];  % output 0 pad values as default
    end
    % resize test image to training size with bicubic interpolation w/ AA
    if ~isempty(params.train_img_dim)
        sz = size(tmp_atlas);
        % don't interpolate image if size is not changing
        if ~all(sz == params.train_img_dim)
            % pad zeros to image if the geometry is different enough
            if sum(abs(diff(unique(sz ./ params.train_img_dim)))) > 1e-3
                ar = sz ./ params.train_img_dim;
                pad_val = round(((max(ar) .* params.train_img_dim) - sz)/2);
                tmp_atlas = padarray(tmp_atlas, pad_val);
                if nargout > 3
                    pad_vals = pad_val;
                end
            end
            if exist('imresize3')
                tmp_atlas = imresize3(tmp_atlas, params.train_img_dim);
            else
                tmp_atlas = resize3d(tmp_atlas, params.train_img_dim);
            end
        end
    end
    dim = size(tmp_atlas); % get resized dimension before padding for future processing
    atlas = pad(tmp_atlas, w, r);
end

