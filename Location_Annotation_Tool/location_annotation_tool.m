function location_annotation_tool
global f_main tabgp tab1 tab2 tab3 work_path
close all;
f_main = figure('Toolbar','none');
get(0,'ScreenSize')
work_path = pwd;
tabgp = uitabgroup(f_main,'Position',[.0 .0 1 1]);
tab1 = uitab(tabgp,'Title','������ע');
tab2 = uitab(tabgp,'Title','�����ע');
tab3 = uitab(tabgp,'Title','reserved');
end



