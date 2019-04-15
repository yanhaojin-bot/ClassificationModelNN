function[target] = getTarget(labels)
    num = size(labels,1)
    target = [];
    for i = 1:num
        if labels(i,1) == 1
            target=[target [1;0;0;0;0;0]];
        elseif labels(i,1) == 2
            target=[target [0;1;0;0;0;0]];
        elseif labels(i,1) == 3
            target=[target [0;0;1;0;0;0]];
        elseif labels(i,1) == 4
            target=[target [0;0;0;1;0;0]];
        elseif labels(i,1) == 5
            target=[target [0;0;0;0;1;0]];
        elseif labels(i,1) == 6
            target=[target [0;0;0;0;0;1]];
        end
    end
end
            
            