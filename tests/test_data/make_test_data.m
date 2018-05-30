% create training and normal testing object (one and the same)
sz = 30;
m = floor(sz/2);
range = 10;
range2 = 3;
a = m-range;
b = m+range;
c = m-range2;
d = m+range2;
test=load_untouch_nii('/Users/jreinhold/Research/Prince/code/replica/REPLICA_release_v01/data/training01/training01_01_mprage_pp.nii');
test.fileprefix = 'test';
test.img = int16(zeros(sz,sz,sz));
test.img(a:b,a:b,a:b) = 100;
test.img(c:d,c:d,c:d) = 200;
test.img(m,m,m) = 300;
test.hdr.dime.dim = [3 sz sz sz 1 1 1 1];
test.hdr.dime.voxoffset = 0;
test.hdr.dime.glmax
save_untouch_nii(test, 'tests/test_data/test.nii');

% create test mask
mask = test;
mask.img(a:b,a:b,a:b) = 1;
save_untouch_nii(mask, 'tests/test_data/mask.nii');

% create smaller image to test resize function
smaller = test;
sz = 25;
m = floor(sz/2);
range = 8;
range2 = 2;
a = m-range;
b = m+range;
c = m-range2;
d = m+range2;
smaller.img = zeros(sz,sz,sz);
smaller.img(a:b,a:b,a:b) = 100;
smaller.img(c:d,c:d,c:d) = 200;
smaller.img(m,m,m) = 300;
smaller.hdr.dime.dim = [3 sz sz sz 1 1 1 1];
save_untouch_nii(smaller, 'tests/test_data/test_small.nii');

% create odd shape image to test resize/pad function
smaller = test;
sz = [25 20 40];
m = floor(sz/2);
range = 8;
range2 = 2;
a = m-range;
b = m+range;
c = m-range2;
d = m+range2;
smaller.img = zeros(sz);
smaller.img(a(1):b(1),a(2):b(2),a(3):b(3)) = 100;
smaller.img(c(1):d(1),c(1):d(1),c(1):d(1)) = 200;
smaller.img(m(1),m(2),m(3)) = 300;
smaller.hdr.dime.dim = [3 sz(1) sz(2) sz(3) 1 1 1 1];
save_untouch_nii(smaller, 'tests/test_data/test_odd.nii');