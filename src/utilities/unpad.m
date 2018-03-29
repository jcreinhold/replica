function out = unpad(img, w, r, dim)
%UNPAD unpad image according to (some) specificiation
    i = 4*(w(1) + r)+1:4*(w(1) + r)+dim(1);
    j = 4*(w(2) + r)+1:4*(w(2) + r)+dim(2);
    k = 4*(w(3) + r)+1:4*(w(3) + r)+dim(3);
    out = img(i, j, k);
end

