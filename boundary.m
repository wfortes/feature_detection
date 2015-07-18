clear all
img_sz_set = [32,64];%,128,256,512];
img_index_set = [1,8,9];
type_set = 1;%[0,1];
[dir_a,dir_b]=mkdirvecs(20);
shape = 'half_square_h';
%--------------------------------------------------------------------------
for img_sz = img_sz_set
    if img_sz==32
        N_proj_set = [2,4,6,8,10,12,14,16];
    elseif img_sz==64
        N_proj_set = [2,4,8,12,16,20,24,28,32];
    elseif img_sz==128
        N_proj_set = [4,8,16,20,24,28,32,40,48,56,64];
    elseif img_sz==256
        N_proj_set = [8,16,32,40,48,56,64,72,80,88,96,104];
    elseif img_sz==512
        N_proj_set = [8,16,32,48,64,72,80,88,96,104,112,120,136,152,168,184,200];
    end
    
    for img_index = img_index_set;
        for type_code = type_set;
            for N_proj = N_proj_set;
                %--------------------------------------------------------------------------
                if type_code == 0
                    type = 'grid';
                    M = mkmatrix(img_sz,img_sz,dir_a(1:N_proj),dir_b(1:N_proj));
                elseif type_code == 1
                    type = 'strip';
                    address = '/export/scratch1/fortes/PhD_files/Load/angles_eq_distr/';
                    M = loadmatrix(address,img_sz,N_proj,type,'matrix');
                end
                P = img_read(img_index,img_sz);
                P = reshape(P,img_sz^2,1);
                P = double(P);
                P = P/norm(P,inf); % only for binary images
                Q = M*P;
                %--------------------------------------------------------------------------
                dim_shape = 4*img_sz/32;
                for shape_value = [0:1]
                    if shape_value == 0
                        vector = ones(img_sz^2,1);
                    else
                        vector = zeros(img_sz^2,1);
                    end
                    for row = 1:img_sz-dim_shape+1
                        for column = 1:img_sz-dim_shape+1
                            %--------------------------------------------------------------------------
                            [answer2 answer3 vector px_idx] = shape_scan(M,Q,row,column,dim_shape,img_sz,shape,shape_value,N_proj,vector);
                            %--------------------------------------------------------------------------
                            img = num2str(img_index);
                            sz = num2str(img_sz);
                            proj = num2str(N_proj);
                            r = num2str(row);
                            c = num2str(column);
                            v = num2str(shape_value);
                            address = strcat('/ufs/fortes/Desktop/PhD_m_files/tomography/consistency_analisys/boundary/');
                            filename = strcat(address,sz,'/',type,'/Im',img,'/v',v,'/boundary-Im',img,'-sz',sz,'-p',proj,'-r',r,'-c',c,'-',type,'-v',v);
                            
%                             data.vector = vector;
                            data.answer2 = answer2;
                            data.answer3 = answer3;
                            data.px_idx = px_idx;
                            save(filename,'data');
                        end
                    end
                end
            end
        end
    end
end

