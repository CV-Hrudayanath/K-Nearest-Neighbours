function num = class_no( data, inp , no_of_classes)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

for i = 1:no_of_classes
   if strcmp(data{1}(i),inp) == 1
       index = i;
   end
end
num = index;

end

