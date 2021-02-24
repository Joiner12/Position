function location_annotation_tool
global f_main tabgp tab1 tab2 tab3 work_path
close all;
f_main = figure('Toolbar','none');
get(0,'ScreenSize')
work_path = pwd;
tabgp = uitabgroup(f_main,'Position',[.0 .0 1 1]);
tab1 = uitab(tabgp,'Title','单个标注');
tab2 = uitab(tabgp,'Title','多个标注');
tab3 = uitab(tabgp,'Title','reserved');
end



