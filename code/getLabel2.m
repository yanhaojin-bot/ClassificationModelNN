function[labels] = getLabel2(target)
    num = size(target,2)
    labels = [];
    for i = 1:num
        if target(:,i)==[1;0;0;0;0]
            labels(1,i) = 1;
        elseif target(:,i)==[0;1;0;0;0] 
            labels(1,i) = 2;
        elseif target(:,i)==[0;0;1;0;0]
            labels(1,i) = 3;
        elseif target(:,i)==[0;0;0;1;0]
            labels(1,i) = 4;
        elseif target(:,i)==[0;0;0;0;1]
            labels(1,i) = 5;
        end
    end
end