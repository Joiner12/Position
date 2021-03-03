clc;
load('D:\Code\BlueTooth\pos_bluetooth_matlab\data\std_diss.mat');
%%
cm_1 = m_1(m_1 > -60);
cm_2 = m_2(m_2 > -75);
cm_3 = m_3;
cm_4 = m_4(m_4 > -80);
cm_5 = m_5;
cm_6 = m_6;
cm_7 = m_7(m_7 > -70);
cm_8 = m_8(m_8 > -80);
cm_9 = m_9;
cm_10 = m_10(m_10 > -80);
cm_11 = m_11(m_11 > -74);
cm_12 = m_12(m_12 > -73);
cm_13 = m_13;
cm_14 = m_14;
cm_15 = m_15;
cm_16 = m_16;
cm_17 = m_17;
cm_18 = m_18;

%% 
h = histfit(cm_1,max(cm_1)-min(cm_1),'normal');
