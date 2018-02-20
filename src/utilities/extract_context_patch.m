function contextPatch = extract_context_patch(I, i, j, k, ...
                                              r1, r2, r3, r4, ...
                                              w1, w2, w3, w4, orig)
%EXTRACT_CONTEXT_PATCH extracts context descriptors, see [1]
%
%   Args:
%
%   Output:
%       contextPatch 
%
%   References:
%     [1] A. Jog, et al., ``Random forest regression for magnetic resonance
%         image synthesis'', Medical Image Analysis, 35:475-488, 2017.

vecx = i - orig(1);
vecy = j - orig(2);
vec = [vecx; vecy];

if (vecx^2 + vecy^2) ~= 0
    unit_vec = (-vec / sqrt(vecx^2+vecy^2))';
else
    unit_vec = [0, 0];
end

r45 = exp(1i*pi/4);
uv = complex(unit_vec(1), unit_vec(2));
uvs = [unit_vec; zeros(7,2)];
for ii=2:8
    uv = uv * r45;
    uvs(ii, :) = [real(uv), imag(uv)];
end

Lw1 = w1(1) * w1(2) * w1(3);
Lw2 = w2(1) * w2(2) * w2(3);
Lw3 = w3(1) * w3(2) * w3(3);
Lw4 = w4(1) * w4(2) * w4(3);

rs = [r1, r2, r3, r4];
ws = [w1; w2; w3; w4];
Lws = [Lw1, Lw2, Lw3, Lw4];

contextPatch = zeros(length(uvs), 4);

for ii=1:4
    zr = zeros(1, length(uvs));
    w = ws(ii,:);
    Lw = Lws(ii);
    r = rs(ii);
    for jj=1:length(zr)
        newvec = r * uvs(jj,:);
        newpointx = floor(i + newvec(1));
        newpointy = floor(j + newvec(2));
        newpointz = k;
        npxx = newpointx-((w(1) - 1) / 2):newpointx+(w(1) - 1)/2;
        npyy = newpointy-((w(2) - 1) / 2):newpointy+(w(2) - 1)/2;
        npzz = newpointz-((w(3) - 1) / 2):newpointz+(w(3) - 1)/2;
        zr(jj) = mean(reshape(I(npxx, npyy, npzz), [Lw, 1]));
    end
    contextPatch(:,ii) = zr';
end

contextPatch = reshape(contextPatch, [numel(contextPatch) 1]);

end
