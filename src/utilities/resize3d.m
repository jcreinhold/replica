function resized = resize3d(img, target_dim)
%RESIZE3D poor man's replacement for imresize3 (don't use it if you have
%imresize3) this currently does *not* filter before down sampling, aliasing
    sz = size(img);
    scale = target_dim ./ sz;
    T = affine3d([scale(1) 0 0 0; 0 scale(2) 0 0; 0 0 scale(3) 0; 0 0 0 1]);
    resized = imwarp(img, T, 'cubic');
    if ~all(size(resized) == target_dim)
        df = abs(target_dim - size(resized));
        h = floor(df/2);
        resized = resized(1+h(1):end-h(1),1+h(2):end-h(2),1+h(3):end-h(3));
        if any(df >= 10) || ~all(size(resized) == target_dim)
            error(['something went wrong with the resizing, target dim: ' ...
                   '%d x %d x %d, resized dim: %d x %d x %d'], target_dim, size(resized))
        end
    end
end

