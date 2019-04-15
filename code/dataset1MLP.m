clear all
importfile('trafficsign');
t=cputime;      %record the start time of the program
nhidden = 50;
rts = 1;
total_training_acc = 0;
total_testing_acc = 0;
total_cm = zeros(6,6);
 
for loops=1:rts
%phogsamples = phogsamples';
%phoglabels = getTarget(phoglabels);
%net=newff(phogsamples,phoglabels,nhidden,{'tansig'},'traingd');
[xtrain,xtest,t_train_plus, t_test_plus] = divideDataset1()
net=newff(xtrain,t_train_plus,nhidden,{'tansig'},'traingd');
% train net
net.divideParam.trainRatio = 0.8; % training set [%]
net.divideParam.valRatio = 0.1;  % validation set [%]
net.divideParam.testRatio = 0.1; % test set [%]
net.trainParam.epochs = 1000;
% Learning rate & momentum set
net.trainParam.lr = 0.10;
net.trainParam.mc = 0.85;
% train a neural network
[net,tr,Y,E] = train(net,xtrain,t_train_plus);

% show network
%view(net);

plot(log(tr.tperf),'r', 'LineWidth', 1);
hold on;
performance = perform(net,t_train_plus,Y);
%plotperform(tr);
%plottrainstate(tr);
Y_test = sim(net,xtest);

% confusion matrix
cm = confusionmat(getLabel1(getcls(Y_test)),getLabel1(t_test_plus));
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
training_acc = rate(getcls(Y), t_train_plus)
testing_acc = rate(getcls(Y_test), t_test_plus)
total_training_acc = training_acc + total_training_acc;
total_testing_acc = testing_acc + total_testing_acc;
total_cm = total_cm + cm; 
end

e =cputime -t;    
disp('Finshing!');
disp(['Average Accuracy of MLP in training set is: ' num2str(total_training_acc/rts)]);
disp(['Average Accuracy of MLP in testing set is: ' num2str(total_testing_acc/rts)]);
disp(['Average CPU runningtime of MLP is: ' num2str(e/rts)]); 