function get_param_struct_params(ps)
    % Size of patch in lowest resolution
    assignin('caller','Nsub4',ps.Nsub4);
    assignin('caller','Lsub4',prod(ps.Nsub4));

    % Size of patch in the next higher resolution
    assignin('caller','Nsub2',ps.Nsub2);
    assignin('caller','Lsub2',prod(ps.Nsub2));

    % patch size from the upsampled image
    assignin('caller','N2sub2',ps.N2sub2);
    assignin('caller','L2sub2',prod(ps.N2sub2));

    % Size of patch in the original highest resolution
    assignin('caller','N',ps.N);
    assignin('caller','L',prod(ps.N));

    % patch size from the upsampled image
    assignin('caller','N2',ps.N2);
    assignin('caller','L2',prod(ps.N2));

    % get all those r's and w's
    assignin('caller','r1_1',ps.r1{1});
    assignin('caller','r2_1',ps.r2{1});
    assignin('caller','r3_1',ps.r3{1});
    assignin('caller','r4_1',ps.r4{1});

    assignin('caller','w1_1',ps.w1{1});
    assignin('caller','w2_1',ps.w2{1});
    assignin('caller','w3_1',ps.w3{1});
    assignin('caller','w4_1',ps.w4{1});

    assignin('caller','r1_2',ps.r1{2});
    assignin('caller','r2_2',ps.r2{2});
    assignin('caller','r3_2',ps.r3{2});
    assignin('caller','r4_2',ps.r4{2});

    assignin('caller','w1_2',ps.w1{2});
    assignin('caller','w2_2',ps.w2{2});
    assignin('caller','w3_2',ps.w3{2});
    assignin('caller','w4_2',ps.w4{2});

    assignin('caller','r1_4',ps.r1{3});
    assignin('caller','r2_4',ps.r2{3});
    assignin('caller','r3_4',ps.r3{3});
    assignin('caller','r4_4',ps.r4{3});

    assignin('caller','w1_4',ps.w1{3});
    assignin('caller','w2_4',ps.w2{3});
    assignin('caller','w3_4',ps.w3{3});
    assignin('caller','w4_4',ps.w4{3});
end