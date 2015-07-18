function [answer_reduced answer_entire vector px_idx] = shape_scan(W,p,row,column,dim_shape,dim,shape,shape_value,N_proj,vector)
%
[px_idx shape_value_vec] = build_shape(row,column,dim_shape,dim,shape,shape_value);

%---------------------- reduced system ------------------------------------

q = p - W(:,px_idx)*shape_value_vec;                % new right-hand side
M = W;
M(:,px_idx) = [];                                   % Reduced matrix
%
[x_ls,~,~] = cgls_W(M, q, [], 100, 1e-5); 
[r,~,~,~,~] = round2binary(x_ls);
sqradius = norm(q,1)/N_proj-dot(x_ls,x_ls);         % squared radius which defines the hypersphere
answer_reduced = norm(r-x_ls)^2-sqradius;           % positive means the given image is not a sub_image

%---------------------- entire system -------------------------------------

[x_ls,~,~] = cgls_W(W, p, [], 100, 1e-5);
[round_x_ls,~,~,~,~] = round2binary(x_ls);
round_x_ls(px_idx) = shape_value_vec;               % rounded x_ls receives sntries from given sub-image
sqradius = norm(p,1)/N_proj-dot(x_ls,x_ls);         % squared radius which defines the hypersphere
answer_entire = norm(round_x_ls-x_ls)^2-sqradius;   % positive means the given image is not a sub_image

%--------------------------------------------------------------------------

if answer_reduced <= 0 && answer_entire <= 0        % if "could be" then
    vector(px_idx) = shape_value_vec;
end

%--------------------------------------------------------------------------

function [piece shape_value_vec] = build_shape(row,column,dim_shape,dim,shape,shape_value)
%
piece=[];

if strcmp(shape,'square')
    for i = 0:dim_shape-1
        initial_pixel = dim*(column+i-1)+row;
        piece_aux = initial_pixel:initial_pixel+dim_shape-1;
        piece = union(piece,piece_aux);
    end
    shape_value_vec = shape_value*ones(length(piece),1);
elseif strcmp(shape,'circle')
    radius = dim_shape/2;
    n = dim;
    for i=1:n % column index
        for j=1:n % row index
            x = j-column;
            y = i-row;
            if (x^2+y^2)< (radius)^2
                piece_aux = dim*(i-1)+j;
                piece = union(piece,piece_aux);
            end
        end
    end
    shape_value_vec = shape_value*ones(length(piece),1);
elseif strcmp(shape,'half_square_h')
    for i = 0:dim_shape-1
        initial_pixel = dim*(column+i-1)+row;
        piece_aux = initial_pixel:initial_pixel+dim_shape-1;
        piece = union(piece,piece_aux);
        l_p = length(piece_aux);
        shape_value_vec(1+i*dim_shape:l_p/2+i*dim_shape,1) = shape_value*ones(l_p/2,1);
        shape_value_vec(l_p/2+i*dim_shape+1:l_p+i*dim_shape,1) = (1-shape_value)*ones(l_p/2,1);
    end
end