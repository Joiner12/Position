classdef markdown_tool

    methods (Static)

        function batch_remove(tar_folder, varargin)
            % 功能: 批量删除文件
            % 定义: function batch_remove(tar_folder, varargin)
            % 输入:
            %       tar_folder,目标文件夹;
            %       varargin,可变参数;
            % 输出:
            %       none

            % varargin(key,value)
            % 'name_filter',名字过滤器
            % 'suffix_filter',文件后缀名

            if ~isfolder(tar_folder)
                disp('target folder is not an exist folder');
                return;
            end

            %% todo: 完善
            % name filter
            name_filter = cell(0);

            if any(strcmpi(varargin, 'name_filter'))
                name_filter = varargin{find(strcmpi(varargin, 'name_filter')) + 1};
            end

            % suffix filter
            suffix_filter = cell(0);

            if any(strcmpi(varargin, 'suffix_filter'))
                suffix_filter = varargin{find(strcmpi(varargin, 'suffix_filter')) + 1};
            end

            %%  temporary function
            dir_detail = dir(tar_folder);

            for k = 3:length(dir_detail)

                if ~isempty(regexp(dir_detail(k).name, '(location-|location-temp)\d.*.png', 'ONCE'))
                    to_del_file = fullfile(dir_detail(k).folder, dir_detail(k).name);
                    delete(to_del_file);
                    fprintf('delete %s \n', to_del_file);
                end

            end

        end

    end

    methods (Static)

        function write_to_markdown(tar_md_file, tar_folder)
            % 批量写markdown文件
            % tar_md_file = 'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\定位过程分析.md';
            % tar_folder = 'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\temp-location-1';
            tar_pic = cell(0);
            dir_folder = dir(tar_folder);

            if isempty(fieldnames(dir_folder))
                return;
            end

            for k = 1:length(dir_folder)
                exp_temp = regexp(dir_folder(k).name, 'location-temp\d*.png', 'match');

                if ~isempty(exp_temp)
                    tar_pic{length(tar_pic) + 1} = fullfile(dir_folder(k).folder, exp_temp{1:end});
                end

            end

            if true
                fildId = fopen(tar_md_file, 'w');
                fprintf(fildId, "**%s** \n", string(datetime('now')))

                for j = 1:length(tar_pic)
                    template_temp = '<div><img src="pic-path" style="zoom:150%%;" />\n<p align="center">label</p></div>\n';
                    template_temp = strrep(template_temp, 'pic-path', strrep(tar_pic{j}, '\', '\\'));
                    template_temp = strrep(template_temp, 'label', strcat('location-', num2str(j)));
                    %template_temp = strcat('wangde',num2str(j),'\n');
                    fprintf(fildId, template_temp);
                    fprintf(fildId, '\n');
                end

                fclose(fildId);
            end

            disp('write finished')
        end

    end

end
