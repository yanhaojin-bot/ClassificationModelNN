clear all
importfile('logo');

t=cputime;      %record the start time of the program
nhidden = 50;
rts = 1;
total_training_acc = 0;
total_testing_acc = 0;
total_cm = zeros(5,5);
for loops=1:rts
%eohsamples = eohsamples';
%eohlabels = getTarget(eohlabels);
%net=newff(eohsamples,eohlabels,nhidden,{'tansig'},'traingd');
[xtrain,xtest,t_train_plus, t_test_plus] = divideDataset2()
net=newff(xtrain,t_train_plus,nhidden,{'tansig'},'traingd');
% train net
net.divideParam.trainRatio = 0.8; % training set [%]
net.divideParam.valRatio = 0.1;  % validation set [%]
net.divideParam.testRatio = 0.1; % test set [%]
net.trainParam.epochs = 1000;
% Learning rate & momentum set
net.trainParam.lr = 0.10;
net.trainParam.mc = 0.8;
% train a neural network
[net,tr,Y,E] = train(net,xtrain,t_train_plus);
% show network
%view(net);

performance = perform(net,t_train_plus,Y);
mse = mean(mean((Y-t_train_plus).^2));
plotperform(tr);

%simulate xtest
Y_test = sim(net,xtest);

% confusion matrix
cm = confusionmat(getLabel2(getcls(Y_test)),getLabel2(t_test_plus));
if size(cm,2) ~= 5
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
    end
        
cm=[cm(1:i-1,:); [0,0,0,0]; cm(i:end,:)];
cm = cm'
cm=[cm(1:i-1,:); [0,0,0,0,0]; cm(i:end,:)];
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