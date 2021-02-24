% location_annotation_tool
add_lat_lon_labels(1,1);

%% 
clc;
vars = {'originfile','overwrite','targetfolder'};
any(strcmpi(vars,'originfile'));
tmp = strcmpi(vars,'originfile')|strcmpi(vars,'overwrite')|strcmpi(vars,'targetfolder');
if any(tmp)
    NOP = vars{find(tmp)+1};
    tmp(find(tmp)+1)=1;
    vars = vars(~tmp);
end