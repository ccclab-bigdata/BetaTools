clc

fs = 30000;
levels = 11;
nodes = 1;

for i=0:levels
    step = fs/nodes;
    disp(strcat('L:',num2str(i),'------------------'));
    for j=1:nodes
        %disp(strcat('node:',num2str(j),'step:',num2str(step)));
        disp(strcat('(',num2str(i),',',num2str(j-1),'):',num2str((j-1)*step),'-',num2str(j*step)));
        if(j>10)
            disp('...');
            break;
        end
    end
    nodes = nodes*2;
end