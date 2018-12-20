% Binarization

tic

close all
clc, clear;

addpath(genpath(cd));

%%%% initial setting
load = 'C:\Users\owner\Desktop\KIAT\raw\reconstructed';
save = 'C:\Users\owner\Desktop\KIAT\binarized';
num = 10;
iter = 5;

%%%% load
temp = inputdlg({'Load','Save','# of Images','# of iteration'},' ',1,{sprintf('%s',load),sprintf('%s',save),sprintf('%d',num),sprintf('%d',iter)});
if size(temp,1)==0
    return;
end
load = temp{1};
save = temp{2};
num = str2double(temp{3});
iter = str2double(temp{4});

%%%% initialization
[m,n] = size(imread(sprintf('%s/1.tif',load)));

%%%% processing
for i=1:num
    step1 = im2double(imread(sprintf('%s/%d.tif',load,i)));
    
    if i==1
        th = graythresh(step1);
    end
    step2 = imbinarize(step1,th*0.9);
    
    if i==1
        track = round(m/2);
        while (1)
            step3 = bwselect(step2,track,round(n/2),8);
            if sum(sum(step3))>150
                break;
            end
            track = track+1;
        end
    else
        [y,x] = find(step3==1);
        step3 = bwselect(step2,x,y,4);
    end
    
    step4 = step3;
    for j=1:iter
        step4 = padarray(step4,[1,1]);
        step4 = step4(1:m,2:n+1)|step4(2:m+1,1:n)|step4(2:m+1,2:n+1)|step4(2:m+1,3:n+2)|step4(3:m+2,2:n+1);
    end
    step4 = ~step4;
    
    step5 = step4-bwselect(step4,1,1,4);
    
    step6 = step5;
    for j=1:iter
        step6 = padarray(step6,[1,1]);
        step6 = step6(1:m,2:n+1)|step6(2:m+1,1:n)|step6(2:m+1,2:n+1)|step6(2:m+1,3:n+2)|step6(3:m+2,2:n+1);
    end
    
    if i==1
        imshow([step1,step2,step3;step4,step5,step6]);
    end
    imwrite(step6,sprintf('%s/%d.tif',save,i));
end

toc