sz = 30;
m = floor(sz/2);
range = 10;
a = m-range;
b = m+range;
test=load_untouch_nii('/Users/jreinhold/Research/Prince/Code/REPLICA_release_v01/data/training01/training01_01_mprage_pp.nii');
test.fileprefix = 'test';
test.img = zeros(sz,sz,sz);
test.img(a:b,a:b,a:b) = 100;
test.img(m,m,m) = 200;
test.hdr.dime.dim = [3 sz sz sz 1 1 1 1];
save_untouch_nii(test, 'tests/test_data/test.nii');