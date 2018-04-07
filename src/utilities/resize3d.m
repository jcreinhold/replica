function resized = resize3d(img, target_dim)
%RESIZE3D poor man's replacement for imresize3 (don't use it if you have
%imresize3) this currently does *not* filter before down sampling, aliasing
    sz = size(img);
    scale = target_dim ./ sz;
    T = affine3d([scale(1) 0 0 0; 0 scale(2) 0 0; 0 0 scale(3) 0; 0 0 0 1]);
    resized = imwarp(img, T, 'cubic');
    if ~all(size(resized) == target_dim)
        df = floor(abs(target_dim - size(resized)/2));
        resized = resized(df(1):end-df(1),df(2):end-df(2),df(3):end-df(3));
        if ~all(size(resized) == target_dim)
            error(['something went wrong with the resizing, target dim: ' ...
                   '%d x %d x %d, actual dim: %d x %d x %d'], target_dim, size(resized))
        end
    end
end

