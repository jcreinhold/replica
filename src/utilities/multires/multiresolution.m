function [img, grid] = multiresolution(img, H, res)
%MULTIRESOLUTION create 3 different resolution images based on user input
%
%   Args:
%       img: img to operate on
%       H: convolving kernel (see fspecial3)
%       res: resolution number (1=low,2=med,3=high)
%
%   Output:
%       img: reinterpolated or downsampled img
%       grid: grid on which img was reinterpd or downsamped

    [img, grid] = reinterpolate(img);
    if res <= 2
        [img, grid] = downsample_by_2(img, H);
    end
    if res <= 1
        [img, grid] = downsample_by_2(img, H);
    end
end

function [img_interp, interp_grid] = reinterpolate(img)
    dim = size(img);
    dimrem = 1 - (dim/2 - floor(dim/2));
    [ii,jj,kk] = get_indices(dim, dimrem);
    [Xi,Yi,Zi] = meshgrid(ii,jj,kk);
    img_interp = interp3(img, Xi, Yi, Zi);
    img_interp(isnan(img_interp)) = 0;
    interp_grid = {Xi, Yi, Zi};
end

function [img_ds, interp_grid] = downsample_by_2(img, H)
    img_lpf = imfilter(img, H, 'replicate');
    img_ds = img_lpf(1:2:end, 1:2:end, 1:2:end);
    [img_ds, interp_grid] = reinterpolate(img_ds);
end

function [ii, jj, kk] = get_indices(dim, dimrem)
    ii = dimrem(2)+0.5:1:dim(2)-(dimrem(2)-0.5);
    jj = dimrem(1)+0.5:1:dim(1)-(dimrem(1)-0.5);
    kk = dimrem(3)+0.5:1:dim(3)-(dimrem(3)-0.5);
end