function MSE= MSE(im1, im2);
[M, N] = size(im1);
error = im1 - (im2);
MSE = sum(sum(error .* error)) / (M * N);
disp(MSE);
end