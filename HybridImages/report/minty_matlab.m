sigma = 3.5;
win_size = round(8.0 * sigma + 1.0);
if (rem(win_size,2) == 0) 
    win_size = win_size + 1;
end
pad = (win_size - 1) / 2;
gaussian_temp = gaussian_template(win_size,sigma);

img1 = imread('data/fish.bmp','bmp');
img2 = imread('data/submarine.bmp','bmp');

img_1_R = double(img1(:,:,1));
img_1_G = double(img1(:,:,2));
img_1_B = double(img1(:,:,3));


img1 = padarray(img1, [pad pad], 'both');
img2 = padarray(img2, [pad pad], 'both');


img_1_R = convolve(img_1_R,gaussian_temp);
img_1_G = convolve(img_1_G,gaussian_temp);
img_1_B = convolve(img_1_B,gaussian_temp);
% Remove the padding post convolution
img_1_R = img_1_R(pad+1:end-pad,pad+1:end-pad);
img_1_G = img_1_G(pad+1:end-pad,pad+1:end-pad);
img_1_B = img_1_B(pad+1:end-pad,pad+1:end-pad);
img_1_low = cat(3, img_1_R, img_1_G, img_1_B );
figure(1), clf;
subplot(2,2,1), imshow(uint8(img_1_low));
subplot(2,2,2), imshow(uint8(img1));

% sigma = 5.0;
% win_size = round(8.0 * sigma + 1.0);
% if (rem(win_size,2) == 0) 
%     win_size = win_size + 1;
% end
% pad = (win_size - 1) / 2;
gaussian_temp = gaussian_template(win_size,sigma);
img_2_R = double(img2(:,:,1));
img_2_G = double(img2(:,:,2));
img_2_B = double(img2(:,:,3));

img_2_R = img_2_R - convolve(img_2_R,gaussian_temp);
img_2_G = img_2_G - convolve(img_2_G,gaussian_temp);
img_2_B = img_2_B - convolve(img_2_B,gaussian_temp);
% Remove the padding post convolution
img_2_R = img_2_R(pad+1:end-pad,pad+1:end-pad);
img_2_G = img_2_G(pad+1:end-pad,pad+1:end-pad);
img_2_B = img_2_B(pad+1:end-pad,pad+1:end-pad);
img_2_high = cat(3, img_2_R, img_2_G, img_2_B ) * 1.1;
figure(2), clf;
subplot(2,2,1), imshow(uint8(img_2_high));
subplot(2,2,2), imshow(uint8(img2));

hybrid = uint8(img_1_low + img_2_high);
figure(3), clf;
subplot(3,3,1), imshow(hybrid);
subplot(3,3,2), imshow(img1);
subplot(3,3,3), imshow(img2);

% Resize the image for visualisation purposes
hybrid_bigger = imresize( hybrid, 1.5 );
hybrid_smaller = imresize( hybrid, 0.5 );
figure(4), clf;
subplot(2,2,1), imshow(hybrid_smaller);
subplot(2,2,2), imshow(hybrid_bigger);

imwrite(hybrid, 'fish_submarine.jpg');

% Throw-away Code to resize some images
% img1 = imresize( img1, [340 400] );
% img1 = uint8(img1);
% img2 = imresize( img2, [340 400] );
% img2 = uint8(img2);
% figure(1), clf;
% subplot(2,2,1), imshow(img1);
% subplot(2,2,2), imshow(img2);
% 
% imwrite( img1, 'data/hilary_smaller.jpg' );
% imwrite( img2, 'data/trump_tiny_hands.jpg' );


%Convolution
function convolved = convolve(image,template)

[irows,icols]=size(image);
[trows,tcols]=size(template);
temp(1:irows,1:icols)=0;
trhalf=floor(trows/2); 
tchalf=floor(tcols/2); 

for x = trhalf+1:icols-trhalf 
  for y = tchalf+1:irows-tchalf
    sum=0;
    for iwin = 1:trows 
      for jwin = 1:tcols
        sum=sum+image(y+jwin-tchalf-1,x+iwin-trhalf-1)*template(jwin,iwin);
        temp(y,x)= sum;
      end
    end
  end
end

minim=min(min(temp));
range=max(max(temp))-minim;
convolved = floor( (temp - minim) * 255/range );


