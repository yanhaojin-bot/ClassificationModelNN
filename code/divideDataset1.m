function [xtrain, xtest, t_train_plus, t_test_plus] = divideDataset()

load('trafficsign')

[train test] = crossvalind('HoldOut',size(phogsamples,1),0.2);
xtrain =phogsamples(train,:)';
xtest  =phogsamples(test,:)';
t_train =phoglabels(train,:);
t_test =phoglabels(test,:);

t_train_plus = getTarget(t_train)
t_test_plus = getTarget(t_test)


