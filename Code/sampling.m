function out = sampling( dataset , size , training_set_size ,k , no_of_attributes , no_of_classes, classifier_index,class_data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
file = fopen(dataset);  
%For Iris-data set
data = textscan( file , '%f %f %f %f %s','Delimiter',',');


%For seeds dataset
%data = textscan( file , '%f %f %f %f %f %f %f %s','Delimiter', ' ');

%For Haberman dataset
%data = textscan( file , '%f %f %f %s','Delimiter',','); 



fclose('all');
sampled_index = randsample(size,size);
    
training_set = [];
for i = 1:training_set_size
    p1 = [];
    for j = 1:no_of_attributes
        p = data{j}(sampled_index(i));
        p1 = [ p1 p ]; 
    end
    training_set = [ training_set ; p1]; 
end


test_set = [];
test_set_size = size - training_set_size;
for i = 1:test_set_size
    p1 = [];
    for j = 1:no_of_attributes
        p = data{j}(sampled_index(training_set_size+i));
        p1 = [ p1 p ]; 
    end
    test_set = [ test_set ; p1 ]; 
end    
%disp(sampled_index);
%disp(training_set);




%knn for k =1
if k == 1
    selected_index = [];
    for i = 1:test_set_size
        min = intmax('int64');
        for j = 1:training_set_size
            distance = pdist2(training_set(j,:) , test_set(i,:));
            if distance < min 
                 min = distance;
                min_index = j;
            end
        end
        selected_index = [ selected_index  min_index ];
    end
end
    
%knn for k=3

if k == 3
    selected_index = [];
    min_index3 = 1;
    min_index2 = 1;
    min_index1 =1;
    for i = 1:test_set_size
            min1 = intmax('int64');
            min2 = intmax('int64')-1;
            min3 = intmax('int64')-2;
            for j = 1:training_set_size
                distance = pdist2(training_set(j,:) , test_set(i,:));
                if distance < min3 && distance >= min2 
                     min3 = distance;
                     min_index3 = j;
                end

                if distance < min2 && distance >= min1
                    min3 = min2;
                    min2 = distance;
                    min_index3 = min_index2;
                    min_index2 = j;
                end

                if distance < min1
                    min3 = min2;
                    min2 = min1;
                    min1 = distance;
                    min_index3 = min_index2;
                    min_index2 = min_index1;
                    min_index1 = j;
                end

            end
            %fprintf('%f %f %f %d %d %d\n',min1,min2,min3,min_index1,min_index2,min_index3);
            c1 = class_no(class_data, data{classifier_index}(sampled_index(min_index1)), no_of_classes);
            c2 = class_no(class_data, data{classifier_index}(sampled_index(min_index2)),no_of_classes);
            c3 = class_no(class_data, data{classifier_index}(sampled_index(min_index3)), no_of_classes);
            %decide(c1,c2,c3,min1,min2,min3);
            t = [c1 c2 c3];
            t = sort(t);
            if ((t(1) == t(2) && t(2) ~= t(3)) || ( t(1) ~= t(2) && t(2) == t(3))) 
               selected_index = [ selected_index  min_index2 ];
            else
               selected_index = [ selected_index  min_index1 ];
            end
            
        end
end





%disp(selected_index);
% checking the classifier


count = 0;
confusion_matrix = zeros(no_of_classes);

%Confusion Matrix and Accuracy calculation
for i = 1:test_set_size
    predicted = class_no(class_data, data{classifier_index}(sampled_index(selected_index(i))), no_of_classes) ;
    actual = class_no(class_data, data{classifier_index}(sampled_index(training_set_size+i)), no_of_classes);
    %disp(actual);
    confusion_matrix(actual,predicted) = confusion_matrix(actual,predicted) + 1; 
    if strcmp( data{classifier_index}(sampled_index(selected_index(i))) , data{classifier_index}(sampled_index(training_set_size+i)) ) == 1
        count = count + 1;
    end  
    %disp(data{classifier_index}(sampled_index(training_set_size+i)));
end


fprintf('No of correctly Matched classes are %d\n',count);
accuracy = (count/test_set_size)*100;
fprintf('Accuracy of classifier is %f\n',accuracy);
disp(confusion_matrix);
out = accuracy;




end


