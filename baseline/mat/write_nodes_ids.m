load('nodes.mat');
fileID = fopen('data/nodes_ids.txt','w');
fprintf(fileID,'%s\n',string(nodes_ids));
fclose(fileID);