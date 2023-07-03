% 根据相关性矩阵绘图

data = zeros(6,12);

data(1,:) = [1.07734415106475	0.643362489919992	0.519107196813389	0.569381236451995	0.668989326055374	0.700542014014377	3.56971975517989	0.734346974267794	0.625388036441880	0.616439346101589	0.377541758237497	0.847868840529837];
data(2,:) = [1.09939923619575	3.57056714180702	1.21162772750220	1.13478441507957	0.929968155209715	0.753940260870545	0.713518106626292	3.15335280050541	0.690195386666717	0.650321824252624	0.487895597268626	0.691640093559069];
data(3,:) = [0.841051600243893	1.29917010839141	1.84890438210965	0.784866563371702	1.03565041231673	0.880909950308577	0.621308991554866	0.996641273326661	3.53787108599674	0.788243482475227	0.714576470933023	0.880855573734623];
data(4,:) = [0.859487814804625	0.767283391625723	0.869341756232522	1.60418693976728	1.12714086793274	0.748592791195461	0.913243184337792	0.779117323111534	0.830008404060192	3.01755686432406	0.998853316653228	0.706158253899334];
data(5,:) = [0.608697159621123	0.624157696631300	0.580410596938001	0.662685293446967	1.36657235934463	0.753991858608676	0.536892484427453	0.560294693422218	0.592097815464282	0.607143717655353	3.93766082267684	1.02266280293136];
data(6,:) = [0.940919126184144	1.11537634184649	1.04993408808465	0.870988183365755	1.30200941786963	1.84658872560158	0.994453943115164	0.814606937163245	0.727013037632733	0.701806797757859	0.836847510372691	2.00918043177118];
% data = data';
% A = normalize(data, 2, 'norm');

SHM=SHeatmap(data,'Format','sq');
SHM=SHM.draw();

ax=gca;
ax.XTickLabel={'D_1','D_2','D_3','D_4','D_5','D_6','V_7','V_8','V_9','V_{10}','V_{11}','V_{12}'};
ax.YTickLabel={'\tau_1','\tau_2','\tau_3','\tau_4','\tau_5','\tau_6'};

% 将所有文本对象的字号设置为 14
% cellfun(@(txt) set(txt, 'FontSize', 14), ax.YTickLabel);


ax.FontSize = 10;
SHM.setText();
% SHM.GridVisible = 'off';
SHM.setBox('Color',[255,255,255]./255);
clim([-0.3,1])
% colormap(slanCM(97))
colormap(slanCM(134))