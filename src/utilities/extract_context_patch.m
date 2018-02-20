function contextPatch = extract_context_patch(I, i, j, k, r1, r2, r3, r4, w1, w2, w3, w4, orig)
%EXTRACT_CONTEXT_PATCH Summary of this function goes here
%   Detailed explanation goes here

vecx = i - orig(1);
vecy = j - orig(2);
vecz = k - orig(3);
vec = [vecx; vecy];


if (vecx^2 + vecy^2) ~= 0
    unit_vec = -vec / sqrt(vecx^2+vecy^2);
else
    unit_vec = [0; 0];
end

r45 = exp(1i*pi/4);
uv0 = complex(unit_vec(1), unit_vec(2));

uv45 = uv0 * r45;
unit_vec45 = [real(uv45), imag(uv45)];
uv90 = uv45 * r45;
unit_vec90 = [real(uv90), imag(uv90)];
uv135 = uv90 * r45;
unit_vec135 = [real(uv135), imag(uv135)];
uv180 = uv135 * r45;
unit_vec180 = [real(uv180), imag(uv180)];
uv225 = uv180 * r45;
unit_vec225 = [real(uv225), imag(uv225)];
uv270 = uv225 * r45;
unit_vec270 = [real(uv270), imag(uv270)];
uv315 = uv270 * r45;
unit_vec315 = [real(uv315), imag(uv315)];


Lw1 = w1(1) * w1(2) * w1(3);
Lw2 = w2(1) * w2(2) * w2(3);
Lw3 = w3(1) * w3(2) * w3(3);
Lw4 = w4(1) * w4(2) * w4(3);


newvec = r1 * unit_vec;

newpointx = floor(i + newvec(1));
newpointy = floor(j + newvec(2));
newpointz = k;
zr1_0 = mean(reshape(I(newpointx-((w1(1) - 1) / 2):newpointx+(w1(1) - 1)/2, newpointy-((w1(2) - 1) / 2):newpointy+(w1(2) - 1)/2, newpointz-((w1(3) - 1) / 2):newpointz+(w1(3) - 1)/2), [Lw1, 1]));

%
newvec = r1 * unit_vec45;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr1_45 = mean(reshape(I(newpointx-((w1(1) - 1) / 2):newpointx+(w1(1) - 1)/2, newpointy-((w1(2) - 1) / 2):newpointy+(w1(2) - 1)/2, newpointz-((w1(3) - 1) / 2):newpointz+(w1(3) - 1)/2), [Lw1, 1]));


newvec = r1 * unit_vec90;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr1_90 = mean(reshape(I(newpointx-((w1(1) - 1) / 2):newpointx+(w1(1) - 1)/2, newpointy-((w1(2) - 1) / 2):newpointy+(w1(2) - 1)/2, newpointz-((w1(3) - 1) / 2):newpointz+(w1(3) - 1)/2), [Lw1, 1]));


newvec = r1 * unit_vec135;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr1_135 = mean(reshape(I(newpointx-((w1(1) - 1) / 2):newpointx+(w1(1) - 1)/2, newpointy-((w1(2) - 1) / 2):newpointy+(w1(2) - 1)/2, newpointz-((w1(3) - 1) / 2):newpointz+(w1(3) - 1)/2), [Lw1, 1]));


newvec = r1 * unit_vec180;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr1_180 = mean(reshape(I(newpointx-((w1(1) - 1) / 2):newpointx+(w1(1) - 1)/2, newpointy-((w1(2) - 1) / 2):newpointy+(w1(2) - 1)/2, newpointz-((w1(3) - 1) / 2):newpointz+(w1(3) - 1)/2), [Lw1, 1]));


newvec = r1 * unit_vec225;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr1_225 = mean(reshape(I(newpointx-((w1(1) - 1) / 2):newpointx+(w1(1) - 1)/2, newpointy-((w1(2) - 1) / 2):newpointy+(w1(2) - 1)/2, newpointz-((w1(3) - 1) / 2):newpointz+(w1(3) - 1)/2), [Lw1, 1]));


newvec = r1 * unit_vec270;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr1_270 = mean(reshape(I(newpointx-((w1(1) - 1) / 2):newpointx+(w1(1) - 1)/2, newpointy-((w1(2) - 1) / 2):newpointy+(w1(2) - 1)/2, newpointz-((w1(3) - 1) / 2):newpointz+(w1(3) - 1)/2), [Lw1, 1]));


newvec = r1 * unit_vec315;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr1_315 = mean(reshape(I(newpointx-((w1(1) - 1) / 2):newpointx+(w1(1) - 1)/2, newpointy-((w1(2) - 1) / 2):newpointy+(w1(2) - 1)/2, newpointz-((w1(3) - 1) / 2):newpointz+(w1(3) - 1)/2), [Lw1, 1]));


%%% Now for r2
newvec = r2 * unit_vec;

newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr2_0 = mean(reshape(I(newpointx-((w2(1) - 1) / 2):newpointx+(w2(1) - 1)/2, newpointy-((w2(2) - 1) / 2):newpointy+(w2(2) - 1)/2, newpointz-((w2(3) - 1) / 2):newpointz+(w2(3) - 1)/2), [Lw2, 1]));

%
newvec = r2 * unit_vec45;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr2_45 = mean(reshape(I(newpointx-((w2(1) - 1) / 2):newpointx+(w2(1) - 1)/2, newpointy-((w2(2) - 1) / 2):newpointy+(w2(2) - 1)/2, newpointz-((w2(3) - 1) / 2):newpointz+(w2(3) - 1)/2), [Lw2, 1]));


newvec = r2 * unit_vec90;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr2_90 = mean(reshape(I(newpointx-((w2(1) - 1) / 2):newpointx+(w2(1) - 1)/2, newpointy-((w2(2) - 1) / 2):newpointy+(w2(2) - 1)/2, newpointz-((w2(3) - 1) / 2):newpointz+(w2(3) - 1)/2), [Lw2, 1]));
%

newvec = r2 * unit_vec135;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr2_135 = mean(reshape(I(newpointx-((w2(1) - 1) / 2):newpointx+(w2(1) - 1)/2, newpointy-((w2(2) - 1) / 2):newpointy+(w2(2) - 1)/2, newpointz-((w2(3) - 1) / 2):newpointz+(w2(3) - 1)/2), [Lw2, 1]));


newvec = r2 * unit_vec180;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr2_180 = mean(reshape(I(newpointx-((w2(1) - 1) / 2):newpointx+(w2(1) - 1)/2, newpointy-((w2(2) - 1) / 2):newpointy+(w2(2) - 1)/2, newpointz-((w2(3) - 1) / 2):newpointz+(w2(3) - 1)/2), [Lw2, 1]));


newvec = r2 * unit_vec225;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
newpointx - ((w2(1) - 1) / 2):newpointx + (w2(1) - 1) / 2; newpointy - ((w2(2) - 1) / 2):newpointy + (w2(2) - 1) / 2; newpointz - ((w2(3) - 1) / 2):newpointz + (w2(3) - 1) / 2;
zr2_225 = mean(reshape(I(newpointx-((w2(1) - 1) / 2):newpointx+(w2(1) - 1)/2, newpointy-((w2(2) - 1) / 2):newpointy+(w2(2) - 1)/2, newpointz-((w2(3) - 1) / 2):newpointz+(w2(3) - 1)/2), [Lw2, 1]));


newvec = r2 * unit_vec270;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr2_270 = mean(reshape(I(newpointx-((w2(1) - 1) / 2):newpointx+(w2(1) - 1)/2, newpointy-((w2(2) - 1) / 2):newpointy+(w2(2) - 1)/2, newpointz-((w2(3) - 1) / 2):newpointz+(w2(3) - 1)/2), [Lw2, 1]));
%

newvec = r2 * unit_vec315;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr2_315 = mean(reshape(I(newpointx-((w2(1) - 1) / 2):newpointx+(w2(1) - 1)/2, newpointy-((w2(2) - 1) / 2):newpointy+(w2(2) - 1)/2, newpointz-((w2(3) - 1) / 2):newpointz+(w2(3) - 1)/2), [Lw2, 1]));

%%% for r3
newvec = r3 * unit_vec;

newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr3_0 = mean(reshape(I(newpointx-((w3(1) - 1) / 2):newpointx+(w3(1) - 1)/2, newpointy-((w3(2) - 1) / 2):newpointy+(w3(2) - 1)/2, newpointz-((w3(3) - 1) / 2):newpointz+(w3(3) - 1)/2), [Lw3, 1]));

%
newvec = r3 * unit_vec45;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr3_45 = mean(reshape(I(newpointx-((w3(1) - 1) / 2):newpointx+(w3(1) - 1)/2, newpointy-((w3(2) - 1) / 2):newpointy+(w3(2) - 1)/2, newpointz-((w3(3) - 1) / 2):newpointz+(w3(3) - 1)/2), [Lw3, 1]));
%

newvec = r3 * unit_vec90;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr3_90 = mean(reshape(I(newpointx-((w3(1) - 1) / 2):newpointx+(w3(1) - 1)/2, newpointy-((w3(2) - 1) / 2):newpointy+(w3(2) - 1)/2, newpointz-((w3(3) - 1) / 2):newpointz+(w3(3) - 1)/2), [Lw3, 1]));


newvec = r3 * unit_vec135;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr3_135 = mean(reshape(I(newpointx-((w3(1) - 1) / 2):newpointx+(w3(1) - 1)/2, newpointy-((w3(2) - 1) / 2):newpointy+(w3(2) - 1)/2, newpointz-((w3(3) - 1) / 2):newpointz+(w3(3) - 1)/2), [Lw3, 1]));


newvec = r3 * unit_vec180;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr3_180 = mean(reshape(I(newpointx-((w3(1) - 1) / 2):newpointx+(w3(1) - 1)/2, newpointy-((w3(2) - 1) / 2):newpointy+(w3(2) - 1)/2, newpointz-((w3(3) - 1) / 2):newpointz+(w3(3) - 1)/2), [Lw3, 1]));


newvec = r3 * unit_vec225;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr3_225 = mean(reshape(I(newpointx-((w3(1) - 1) / 2):newpointx+(w3(1) - 1)/2, newpointy-((w3(2) - 1) / 2):newpointy+(w3(2) - 1)/2, newpointz-((w3(3) - 1) / 2):newpointz+(w3(3) - 1)/2), [Lw3, 1]));


newvec = r3 * unit_vec270;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr3_270 = mean(reshape(I(newpointx-((w3(1) - 1) / 2):newpointx+(w3(1) - 1)/2, newpointy-((w3(2) - 1) / 2):newpointy+(w3(2) - 1)/2, newpointz-((w3(3) - 1) / 2):newpointz+(w3(3) - 1)/2), [Lw3, 1]));


newvec = r3 * unit_vec315;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr3_315 = mean(reshape(I(newpointx-((w3(1) - 1) / 2):newpointx+(w3(1) - 1)/2, newpointy-((w3(2) - 1) / 2):newpointy+(w3(2) - 1)/2, newpointz-((w3(3) - 1) / 2):newpointz+(w3(3) - 1)/2), [Lw3, 1]));
%
%

%%% for r4

newvec = r4 * unit_vec;

newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr4_0 = mean(reshape(I(newpointx-((w4(1) - 1) / 2):newpointx+(w4(1) - 1)/2, newpointy-((w4(2) - 1) / 2):newpointy+(w4(2) - 1)/2, newpointz-((w4(3) - 1) / 2):newpointz+(w4(3) - 1)/2), [Lw4, 1]));

%
newvec = r4 * unit_vec45;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr4_45 = mean(reshape(I(newpointx-((w4(1) - 1) / 2):newpointx+(w4(1) - 1)/2, newpointy-((w4(2) - 1) / 2):newpointy+(w4(2) - 1)/2, newpointz-((w4(3) - 1) / 2):newpointz+(w4(3) - 1)/2), [Lw4, 1]));


newvec = r4 * unit_vec90;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr4_90 = mean(reshape(I(newpointx-((w4(1) - 1) / 2):newpointx+(w4(1) - 1)/2, newpointy-((w4(2) - 1) / 2):newpointy+(w4(2) - 1)/2, newpointz-((w4(3) - 1) / 2):newpointz+(w4(3) - 1)/2), [Lw4, 1]));


newvec = r4 * unit_vec135;
newpointx = floor(i + newvec(1));
newpointy = floor(j + newvec(2));
newpointz = k;
zr4_135 = mean(reshape(I(newpointx-((w4(1) - 1) / 2):newpointx+(w4(1) - 1)/2, newpointy-((w4(2) - 1) / 2):newpointy+(w4(2) - 1)/2, newpointz-((w4(3) - 1) / 2):newpointz+(w4(3) - 1)/2), [Lw4, 1]));
%

newvec = r4 * unit_vec180;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr4_180 = mean(reshape(I(newpointx-((w4(1) - 1) / 2):newpointx+(w4(1) - 1)/2, newpointy-((w4(2) - 1) / 2):newpointy+(w4(2) - 1)/2, newpointz-((w4(3) - 1) / 2):newpointz+(w4(3) - 1)/2), [Lw4, 1]));


newvec = r4 * unit_vec225;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr4_225 = mean(reshape(I(newpointx-((w4(1) - 1) / 2):newpointx+(w4(1) - 1)/2, newpointy-((w4(2) - 1) / 2):newpointy+(w4(2) - 1)/2, newpointz-((w4(3) - 1) / 2):newpointz+(w4(3) - 1)/2), [Lw4, 1]));


newvec = r4 * unit_vec270;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr4_270 = mean(reshape(I(newpointx-((w4(1) - 1) / 2):newpointx+(w4(1) - 1)/2, newpointy-((w4(2) - 1) / 2):newpointy+(w4(2) - 1)/2, newpointz-((w4(3) - 1) / 2):newpointz+(w4(3) - 1)/2), [Lw4, 1]));


newvec = r4 * unit_vec315;
newpointx = floor(i+newvec(1));
newpointy = floor(j+newvec(2));
newpointz = k;
zr4_315 = mean(reshape(I(newpointx-((w4(1) - 1) / 2):newpointx+(w4(1) - 1)/2, newpointy-((w4(2) - 1) / 2):newpointy+(w4(2) - 1)/2, newpointz-((w4(3) - 1) / 2):newpointz+(w4(3) - 1)/2), [Lw4, 1]));


zr1 = [zr1_0, zr1_45, zr1_90, zr1_135, zr1_180, zr1_225, zr1_270, zr1_315];
zr2 = [zr2_0, zr2_45, zr2_90, zr2_135, zr2_180, zr2_225, zr2_270, zr2_315];
zr3 = [zr3_0, zr3_45, zr3_90, zr3_135, zr3_180, zr3_225, zr3_270, zr3_315];
zr4 = [zr4_0, zr4_45, zr4_90, zr4_135, zr4_180, zr4_225, zr4_270, zr4_315];

contextPatch = [zr1'; zr2'; zr3'; zr4'];


end
