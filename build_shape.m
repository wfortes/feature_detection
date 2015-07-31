function [piece, shape_value_vec] = build_shape(row, column, dim_shape, dim,shape, shape_value)
%BUILD_SHAPE creates a 2D image with shape given by SHAPE (string),
%pixel value SHAPE_VALUE and dimension dim_shape X dim_shape. This shape is 
%placed on a grid of dimension dim X dim.
%   Input:
%   ROW is the row-th global coordinate
%   COLUMN is the column-th global coordinate
%   DIM_SHAPE is one dimension of shape
%   DIM is one dimension of original image
%   SHAPE is 'square' (flat) or 'half_square_h' (edge)
%   SHAPE_VALUE is 1 (white) or 0 (black)
%   
%	Output:
%   PIECE is vector of global coordinates for shape
%   SHAPE_VALUE_VEC is vector of values for shape
%
% Wagner Fortes 2014/2015 wfortes@gmail.com

piece=[];

if strcmp(shape,'square')
    for i = 0:dim_shape-1
        % placement of (0,0) of the shape onto (row, column) on a dim x dim
        % grid in a vector format
        initial_pixel = dim*(column+i-1)+row; 
        piece_aux = initial_pixel:initial_pixel+dim_shape-1;
        % global coordinates shape 
        piece = union(piece,piece_aux); 
    end
    % ordered value of pixels 
    shape_value_vec = shape_value*ones(length(piece),1);
    
elseif strcmp(shape,'half_square_h')
    for i = 0:dim_shape-1
        % placement of (0,0) of the shape onto (row, column) on a dim x dim
        % grid in a vector format
        initial_pixel = dim*(column+i-1)+row;
        piece_aux = initial_pixel:initial_pixel+dim_shape-1;
        % global coordinates shape 
        piece = union(piece,piece_aux);
        l_p = length(piece_aux);
        % ordered value of pixels
        shape_value_vec(1+i*dim_shape:l_p/2+i*dim_shape,1) = shape_value*ones(l_p/2,1);
        shape_value_vec(l_p/2+i*dim_shape+1:l_p+i*dim_shape,1) = (1-shape_value)*ones(l_p/2,1);
    end
end