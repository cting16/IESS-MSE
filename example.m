load('sub1_A01.mat');
fs=s.SPR(1);
labelnum = s.NS;
fdata = s.fdata;
for i = 1:length(s.Label)
    str = strsplit(s.Label(i,:));
    label{i} = str{1,length(str)-1};
end
name = lower(strsplit(file,'_'));
name = char(name(1));
for index = 1:42
    if strcmp(name,ID2{index,3})
        break
    end
end

s1 = '2020.9.23 14:58:00';
t1 = datevec(s1,'yyyy.mm.dd HH:MM:SS');
s2 = '2020.9.23 15:46:00';
t2 = datevec(s2,'yyyy.mm.dd HH:MM:SS');
t_range = etime(t2,t1); 
if t_range < 10*60
    return
end
s0 = strcat(num2str(s.T0(1)),'.',num2str(s.T0(2)),'.',num2str(s.T0(3)),{32},num2str(s.T0(4)),':',num2str(s.T0(5)),':',num2str(s.T0(6)));
t0 = datevec(s0,'yyyy.mm.dd HH:MM:SS');
tb_0 = etime(t1,t0);
if tb_0 < 0
    tb_0 = 0;
end
num = floor(t_range/(10*60));

t = 1:1/fs:10;
tau = 256;
MSE = zeros(256,16);
ch = [1,3:5,7:10,12:15,17:19,21];

for k = 0:num-1
    tb_s = tb_0 * fs + k*10*60*fs;
    te_s = tb_s + 10*60*fs;
    data = fdata(tb_s+1:te_s,:);
    parfor i = 1:16
        MSE(:,i) = MultiScaleEn(data(:,ch(i)),tau);
    end
    MSEba.Seizure_free.sub1.sleep{1,k+1} = MSE;
end
delete(gcp('nocreate'));
return

%% 
MSEbanew = cal_CI(MSEba,period); %calculate CI for each patient
[MSEba_avg,CI_ba_avg,CI_ba_change] = cal_mCI(MSEbanew,period); %calculate mean CI and the change of CI during the treatment for each patient
