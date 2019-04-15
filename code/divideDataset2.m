function [xtrain, xtest, t_train_plus, t_test_plus] = divideDataset2()

load('logo')

[train test] = crossvalind('HoldOut',size(eohsamples,1),0.2);
xtrain =eohsamples(train,:)';
xtest  =eohsamples(test,:)';
t_train =eohlabels(train,:);
t_test =eohlabels(test,:);

t_train_plus = getTarget(t_train)
t_train_plus = t_train_plus(1:5,:)
t_test_plus = getTarget(t_test)
t_test_plus = t_test_plus(1:5,:)