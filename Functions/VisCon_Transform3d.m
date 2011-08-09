function [ tx, ty, tz ] = VisCon_Transform3d( x, y, z, translate, rotate, scale )

[n, p] = size(x);
point = zeros(4, n * p);
point(4, :) = 1;
for i = 1:n
    point(1:3, (i-1)*p+1:i*p) = [x(i,:); y(i,:); z(i,:)];
end

M1 = makehgtform('scale', scale);
M2 = makehgtform('translate', translate);
M3 = makehgtform('xrotate', rotate(1)) * makehgtform('yrotate', rotate(2)) * makehgtform('zrotate', rotate(3));
point = (M3 * (M2* (M1 * point)));

tx = zeros(n, p);
ty = zeros(n, p);
tz = zeros(n, p);
for i = 1:n
    tx(i,:) = point(1, (i-1)*p+1:i*p);
    ty(i,:) = point(2, (i-1)*p+1:i*p);
    tz(i,:) = point(3, (i-1)*p+1:i*p);
end

end

