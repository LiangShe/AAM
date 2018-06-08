classdef AAM_Model
    % AAM_MODEL Active Apearance Model
    %
    
    properties
        data
        npc_mark % number of PC
        npc_texture
    end
    
    methods
        
        %% constructor
        function me = AAM_Model(data_file)
            load(fullfile(data_file))
            me.data = model;
            me.npc_mark = npc_id_mark;
            me.npc_texture = npc_id_texture;
        end
        
        %% helper
        function examination(me, output_path, output_res)
            if nargin<3
                Model_examination(me.data, output_path)
            else
                Model_examination(me.data, output_path, output_res)
            end
        end
        
        function params = gen_random_params(me, n)
            % generate random paramters
            % n: number of samples to generate
            p_id_mark = gen_randn_param( n, me.data.id_mark);
            p_id_texture = gen_randn_param( n, me.data.id_texture);
            params = [p_id_mark' p_id_texture'];
        end
        
        %% compute_param
        % image and marks to params in PCA space
        function param = compute_param(me, im_data, marks_raw)
            
            ndim = me.npc_mark + me.npc_texture;
            n_faces = length(im_data);
            param = zeros(n_faces, ndim);
            
            for i = 1:n_faces
                
                %fprintf('%d/%d\n', i, n_faces)
                marks = marks_raw(:,:,i);
                im = im_data{i};
                
                resy = size(im,1);
                resx = size(im,2);
                
                texture_template = draw_texture( im, marks, resx, resy, ...
                    me.data.id_mark.mean, me.data.x_texture, me.data.y_texture, me.data.facets );
                
                marks_norm = mark_normalize(marks);
                p_id_mark = me.data.id_mark.eig_vector' * (marks_norm(:) - me.data.id_mark.mean');
                p_id_texture = me.data.id_texture.eig_vector' * (texture_template(:) - me.data.id_texture.mean');
                
                param(i,:) = [p_id_mark' p_id_texture'];
            end
            
        end
        
        %% gen_image_param ()
        % generate image from provided parameters
        function [im_syn, landmarks] = gen_image_param(me, params, output_res)
            n = size(params,1);
            im_syn = zeros([output_res, 3, n]);
            for i = 1:n
                %fprintf('Generating images %d/%d\n',i,n);
                p_id_mark = params(i,1:me.npc_mark)';
                p_id_texture = params(i,me.npc_mark+1:end)';
                [im_syn(:,:,:,i), landmarks(:,:,i)]= AAM_gen_image( p_id_mark, p_id_texture, me.data, output_res);
            end
        end
        
        %% gen_image_internal(index, output_res)
        % index: index of internal images/ training images
        function im_syn = gen_image_internal(me, index, output_res)
            
            if ~isfield(me.data.id_mark, 'score')
                im_syn = [];
                return
            end
            
            n = length(index);
            im_syn = zeros([output_res, 3, n]);
            for i = 1:n
                p_id_mark = me.data.id_mark.score(index(i),:)';
                p_id_texture = me.data.id_texture.score(index(i),:)';
                im_syn(:,:,:,i) = AAM_gen_image( p_id_mark, p_id_texture, me.data, output_res);
            end

        end
        
    end
    
end
    
