function qw = run_knn(dataset , size , training_set_size ,k, no_of_attributes ,no_of_classes ,classifier_index ,classes_file, iterations , kfold_flag)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
file = fopen(classes_file);  
class_data = textscan( file , '%s');
fclose('all');
%disp(class_data);

if kfold_flag == 0
        sum = 0;
        mean_set = [];
        for i = 1:iterations
               fprintf('Iteration %d:\n',i);
               res = sampling( dataset , size , training_set_size , k , no_of_attributes ,no_of_classes, classifier_index,class_data);
               sum = sum + res;
               mean_set = [ mean_set res];
               %fprintf('\n');
        end
        disp('Overall Mean is');
        Mean = sum/iterations;
        disp(Mean);
        disp('Standard Deviation is');
        deviation = std(mean_set);
        disp(deviation);
else
        sum = 0;
        mean_set = [];
        %As 5-fold
        for i = 1:iterations
               fprintf('Iteration %d:\n',i);
               res = kfoldsampling( dataset , size , training_set_size , k , no_of_attributes ,no_of_classes, classifier_index,class_data);
               sum = sum + res;
               mean_set = [ mean_set res];
               fprintf('Mean is %f',res);
               fprintf('\n');
               
        end
        
        
        disp('Overall Grand Mean is');
        Mean = sum/iterations;
        disp(Mean);
        disp('Standard Deviation is');
        deviation = std(mean_set);
        disp(deviation);
end


qw = 1;
end

