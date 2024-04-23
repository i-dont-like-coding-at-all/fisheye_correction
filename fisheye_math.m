% Load fisheye image
images=imageDatastore('fisheye_images');
I=readimage(images,1);

% Get image size
[rows,cols,~]=size(I);

% Image size
corrected_img=zeros(rows,cols,3,"uint8");

% Image parameters
fl=6; % focal length
sw=1; % sensor width

% have to calculate for every point and should involve the radius and the
% angle 
% write for x and y in mesh grid to get everything
% cos of a matrix will take cos of every coordinate

[X,Y]=meshgrid(1:cols,1:rows);
correction_factor=sw/(2*tan(pi*sw/(2*fl)));

r=sqrt(X.^2+Y.^2);
theta=atan2(Y,X);

% Apply fisheye correction formula
r_corrected=r*correction_factor;
X_corrected=r_corrected.*cos(theta);
Y_corrected=r_corrected.*sin(theta);

% Convert corrected coordinates to image coordinates
X_corrected=X_corrected-(cols/2); 
Y_corrected=Y_corrected-(rows/2);

% Interpolation to correct image
for i = 1:3 % for each color channel
    corrected_img(:,:,i)=interp2(X,Y,double(I(:,:,i)),X_corrected,Y_corrected,'linear');
end

% Display original and corrected images
figure;
subplot(1,2,1);
imshow(I);
title('Original Fisheye Image');

subplot(1,2,2);
imshow(corrected_img);
title('Corrected Image');

