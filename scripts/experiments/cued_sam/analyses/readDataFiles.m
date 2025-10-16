directoryName = 'D:\MatlabDirectory\MertKucuk\Cued_SAM\Cued_SAM\behavioralData\submdeneme_B_topLeftShort\block_1';
cd(directoryName)

fileName = 'mdeneme_block1_estimatedOnset.txt';

data=readcell(fileName);
data(1,:)=[];

RTvector = [data{2:end,5}].';

RTvector = repmat(RTvector,[100 1]);
RTvector = repmat(150:50:2000,[1 100]);
RTvector = sort(RTvector);
accuracyVector = {'Long_Press','Short_Press','WKey_Long_Press','WKey_Short_Press','WKey_Correct_Duration'};
Ytiles= quantile(RTvector,[.25 .5 .75 1]);



