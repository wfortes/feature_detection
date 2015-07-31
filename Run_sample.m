% A method to determ whether a selected feature may not exist in a given
% position of reconstrutions from binary tomography. Details:
%   A method for feature detection in binary tomography
%   W. Fortes and K.J. Batenburg
%   DGCI 2013, Vol. 7749 of LNCS, 372-382. Springer.
%
% Wagner Fortes 2014/2015 wfortes@gmail.com


img_index = 1; % select image index
img_sz = 64; % select image dimension 32, 64, 128, 256, 512
N_proj_set = [2,4,8,16,24,32]; %Set of number of projection angles from 1 to 200
[dir_a, dir_b] = mkdirvecs(20); % create directions for projection matrix
shape = 'square'; %'square' (flat) or 'half_square_h' (edge)
%--------------------------------------------------------------------------
% loads image
P = img_read(img_sz, img_index);
P = reshape(P,img_sz^2,1);
P = double(P);
P = P/norm(P,inf); % only for binary images

for N_proj = N_proj_set;
    %--------------------------------------------------------------------------
    % Projection matrix
    M = mkmatrix(img_sz, img_sz, dir_a(1:N_proj), dir_b(1:N_proj));
    % Projetion of image P
    Q = M*P;
    %--------------------------------------------------------------------------
    dim_shape = 4*img_sz/32; % dimension of shape scaled with img_sz
    shape_value = 0; % 0 (black) or 1 (white)
    
    % set of horizontal coordinate pixels to place the pixel (1,1) of probe
    % value between 1 and img_sz-dim_shape+1
    row = 10;  
    % set of horizontal coordinate pixels to place the pixel (1,1) of probe
    % value between 1 and img_sz-dim_shape+1
    column = 10; 
    %--------------------------------------------------------------------------
    % build vector of coordinates for shape and its pixel values
    [piece, shape_value_vec] = build_shape(row, column, dim_shape, img_sz, shape, shape_value);
    %--------------------------------------------------------------------------
    % Check inconsistancy and print it on screen
    consistency4shape(M, Q, N_proj, piece, shape_value_vec);
    %--------------------------------------------------------------------------
end
