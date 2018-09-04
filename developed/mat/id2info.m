function [screen_name, followers_count, friends_count] = id2info(id,T,id_array)
  if any(id_array == id)
    screen_name = table2val(T(id_array == id,2));
    followers_count = table2val(T(id_array == id,3));
    friends_count = table2val(T(id_array == id,4));
  else
    screen_name = '--- ';
    followers_count = -1;
    friends_count = -1;
  end
end