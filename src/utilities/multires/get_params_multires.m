function [I, J, K, orig, n, fg] = get_params_multires(img, ps)
%GET_TRAIN_PARAMS_MULTIRES
%
%   Args:
%       img: an image which we want to get training params for
%
%   Output:
%       I:
%       J:
%       K:
%       orig:
%       n:
%       fg: foreground indices (for saving result image)

    dim = size(img);
    fg = find(img > ps.threshold);
    [I, J, K] = ind2sub(dim, fg);
    orig = floor(dim/2);
    n = length(fg);
end