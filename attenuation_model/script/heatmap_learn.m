%%
load patients
tbl = table(LastName,Age,Gender,SelfAssessedHealthStatus,...
    Smoker,Weight,Location);
h = heatmap(tbl,'Smoker','SelfAssessedHealthStatus');

%%
clc;
tcf('heat')
figure('Name','heat','Color','w')
cdata = [45 60 32; 43 54 76; 32 94 68; 23 95 58];
cdata = magic(4);
heatmap(cdata);