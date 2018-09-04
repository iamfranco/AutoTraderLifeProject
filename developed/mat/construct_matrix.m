% constructs adjacency matrix and saves into 'adjacency.mat'

foa_table = readtable('data/followers_info.txt','Format','%s%s%d%d');
foa_cell = table2cell(foa_table(:,1));
foa = string(foa_cell);
[foa, foa_unique_ind] = unique(foa,'stable');
foa_cell = foa_cell(foa_unique_ind);

foa_to_fofoa_table = readtable('data/followers_followers.csv','Format','%s%s','Delimiter',',');
fofoa_cell = table2cell(foa_to_fofoa_table(:,2));
foa_to_fofoa_cell = table2cell(foa_to_fofoa_table);
[~,foa_to_fofoa_unique_ind] = unique(string(foa_to_fofoa_cell),'rows');
foa_to_fofoa_cell = foa_to_fofoa_cell(foa_to_fofoa_unique_ind,:);
fofoa_cell = unique(fofoa_cell,'stable');

foa_from_frfoa_table = readtable('data/followers_friends.csv','Format','%s%s','Delimiter',',');
frfoa_cell = table2cell(foa_from_frfoa_table(:,2));
foa_from_frfoa_cell = table2cell(foa_from_frfoa_table);
[~,foa_from_frfoa_unique_ind] = unique(string(foa_from_frfoa_cell),'rows');
foa_from_frfoa_cell = foa_from_frfoa_cell(foa_from_frfoa_unique_ind,:);
frfoa_cell = unique(frfoa_cell,'stable');

nodes_ids = [foa_cell;fofoa_cell;frfoa_cell];
nodes_ids = unique(nodes_ids,'stable');

nodes_ind_ids = containers.Map(nodes_ids,1:length(nodes_ids));

folfol_count = length(foa_to_fofoa_cell);
folfri_count = length(foa_from_frfoa_cell);
connections = zeros(folfol_count+folfri_count,2);
prev_f_id = "-1";
wb = waitbar(0,'construct matrix (1/2): Please wait');
for c = 1:folfol_count
  if prev_f_id ~= string(foa_to_fofoa_cell{c,1})
    prev_f_id = string(foa_to_fofoa_cell{c,1});
    i = nodes_ind_ids(foa_to_fofoa_cell{c,1});
    waitbar(c/folfol_count,wb);
  end
  j = nodes_ind_ids(foa_to_fofoa_cell{c,2});
  
  connections(c,:) = [i,j];
end
close(wb)

prev_f_id = "-1";
wb = waitbar(0,'construct matrix (2/2): Please wait');
for c = 1:folfri_count
  if prev_f_id ~= string(foa_from_frfoa_cell{c,1})
    prev_f_id = string(foa_from_frfoa_cell{c,1});
    i = nodes_ind_ids(foa_from_frfoa_cell{c,1});
    waitbar(c/folfri_count,wb);
  end
  j = nodes_ind_ids(foa_from_frfoa_cell{c,2});
  
  connections(c+folfol_count,:) = [j,i];
end
close(wb)

connections_unique = unique(connections,'rows','stable');  % eliminate duplicate rows caused 
                                                    % by 2 level 1 followers 
                                                    % following each others

G = digraph(connections_unique(:,1), connections_unique(:,2));

A = adjacency(G);
save('adjacency.mat','A');
save('layer_cells.mat','foa_cell','fofoa_cell','frfoa_cell');
save('nodes.mat','nodes_ids');
