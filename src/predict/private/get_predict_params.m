function [I, J, K, orig, n, fg] = get_predict_params(subject_t1w)
%GET_PREDICT_PARAMS Summary of this function goes here
%
%   Args:
%       subject_t1w:
%
%   Output:
%       I:
%       J:
%       K:
%       orig:
%       n:
%       fg: foreground indices (for saving result image)

    dim = size(subject_t1w);
    fg = find(subject_t1w > 0);
    [I, J, K] = ind2sub(dim, fg);
    orig = floor(dim/2);
    n = length(fg);
end

