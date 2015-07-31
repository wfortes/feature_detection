function consistency4shape(W, p, N_proj, px_idx, shape_value_vec)
%CONSISTENCY4SHAPE checks the consistency of a given linear system
%for existence of a given shape as in:
%   A method for feature detection in binary tomography
%   W. Fortes and K.J. Batenburg
%   DGCI 2013, Vol. 7749 of LNCS, 372-382. Springer.
%   Input:
%   W is matrix, P is right hand side or projection vector
%   N_PROJ is number of projections angles taken
%   PX_IDX global pixel indexing of shape
%   SHAPE_VALUE_VEC vector of ordered values for shape
%
%
% Wagner Fortes 2014/2015 wfortes@gmail.com

%---------------------- reduced system ------------------------------------

q = p - W(:,px_idx)*shape_value_vec;                % new right-hand side
M = W;
M(:,px_idx) = [];                                   % Reduced matrix
%
x_ls = ls_solver(M, q, [], [], []); 
[r, ~, ~, ~] = round2binary(x_ls);
sqradius = norm(q,1)/N_proj-dot(x_ls,x_ls);         % squared radius which defines the hypersphere
answer_reduced = norm(r-x_ls)^2-sqradius;           % positive means the given image is not a sub_image

%---------------------- entire system -------------------------------------

x_ls = ls_solver(M, p, [], [], []); 
[round_x_ls, ~, ~, ~] = round2binary(x_ls);
round_x_ls(px_idx) = shape_value_vec;               % rounded x_ls receives sntries from given sub-image
sqradius = norm(p,1)/N_proj-dot(x_ls,x_ls);         % squared radius which defines the hypersphere
answer_entire = norm(round_x_ls-x_ls)^2-sqradius;   % positive means the given image is not a sub_image

%--------------------------------------------------------------------------

if answer_reduced > 0 || answer_entire > 0 
    fprintf('Given shape cannot exist at given position for this problem setting\n');
else
    fprintf('No inconsistency was found for this problem setting\n');
end
