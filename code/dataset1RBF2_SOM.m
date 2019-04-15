clear all;

importfile('trafficsign')
t=cputime;        %record the start time of the program      
s = 0;            %counter to sum the accuarcy of the running cycles
rts = 100;          %times to train and test the RBF with SOM
map_l = 6;      %length of the mapsize
total_training_acc = 0;
total_testing_acc = 0;
total_cm = zeros(6,6);
disp(['Map Length=' num2str(map_l)]);
disp('Start...');

for loops=1:rts

%crossvalide train and test for 1
[train test] = crossvalind('HoldOut',size(phogsamples,1),0.2);
xtrain =phogsamples(train,:);
xtest  =phogsamples(test,:);
t_train =phoglabels(train,:);
t_test =phoglabels(test,:);

%reconstruct the t_train output into 6 dimensions
t_train_plus = getTarget(t_train)'

%train datasets to get SOM's center,batch alogrithm is default
sM = som_make(xtrain,'msize',[map_l map_l]);
C = sM.codebook;

somV(sM)

%train the RBF netowrk to calculate the weight and basis values.
[nodenum centerrow]=size(C);
row=size(xtrain,1);
nodeout = zeros(size(xtrain,1),map_l^2);
netout = zeros(size(xtest,1),map_l^2);

for step=1:row                                     %gussian function
    for step1=1:nodenum
        nodeout(step,step1)=exp(-(norm(xtrain(step,:)-C(step1,:))^2)/1000);
    end % this end for step1=1:nodenum
end %this end for step=1:row

%pesudo-inverse to get the weight of the network
weight = pinv(nodeout)*t_train_plus;

%simulate 
simrow=size(xtrain,1);
for step=1:simrow
    for step1=1:nodenum
        netout(step,step1)=exp(-(norm(xtrain(step,:)-C(step1,:))^2)/1000);
    end % this end for step1=1:nodenum
end %this end for step=1:simrow

%output the correspoding traget vectors
target=netout*weight;

%translate output of target dataset into one demension
m_t = target';
[M,I]=max(m_t);
result = I';

%Evaluation function to get accuracy of network
training_acc=sum(result==t_train)/size(t_train,1);

clear netout;
netout = zeros(size(xtest,1),map_l^2);

%simulate 
simrow=size(xtest,1);
for step=1:simrow
    for step1=1:nodenum
        netout(step,step1)=exp(-(norm(xtest(step,:)-C(step1,:))^2)/1000);
    end % this end for step1=1:nodenum
end %this end for step=1:row

%output the correspoding traget vectors
target=netout*weight;

%translate output of target dataset into one demension (1~4)
m_t = target';
[M,I]=max(m_t);
result = I';

% confusion matrix
cm = confusionmat(result, t_test);
if size(cm,2) ~= 6
    if sum(cm(:)==1) == 0
        i = 1;
    elseif sum(cm(:)==2) == 0
        i = 2;
    elseif sum(cm(:)==3) == 0
        i = 3;
    elseif sum(cm(:)==4) == 0
        i = 4;
    elseif sum(cm(:)==5) == 0
        i = 5;
    elseif sum(cm(:)==6) == 0
        i = 6;
    end
        
cm=[cm(1:i-1,:); [0,0,0,0,0]; cm(i:end,:)];
cm = cm'
cm=[cm(1:i-1,:); [0,0,0,0,0,0]; cm(i:end,:)];
cm = cm'
end

%Evaluation function to get accuracy of network
testing_acc=sum(result==t_test)/size(t_test,1);
total_testing_acc = testing_acc + total_testing_acc;
total_training_acc = training_acc + total_training_acc;
total_cm = total_cm + cm; 
end

e=cputime-t;
disp('Finshing!');
disp(['Average Accuracy of RBF with SOM is in training set: ' num2str(total_training_acc/rts)]);
disp(['Average Accuracy of RBF with SOM is in testing set: ' num2str(total_testing_acc/rts)]);
disp(['Average CPU runningtime of RBF with SOM is: ' num2str(e/rts)]); 

