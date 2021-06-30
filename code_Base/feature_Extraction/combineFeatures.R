#files and directory paths
csvLocation_train1 = "datasets/dataset_working/feature_extraction/train_feature_extract_sentiments.csv"
csvLocation_train2 = "datasets/dataset_working/feature_extraction/tweet2vec_final_25Dimensions.csv"
csvLocation_test1 = "datasets/dataset_working/feature_extraction/test_feature_extract_sentiments.csv"
csvLocation_test2 = "datasets/dataset_working/feature_extraction/test_word2vec_feature_extraction.csv"
output_dir_path_fea1 = "datasets/dataset_working/feature_extraction/train_data.csv"
output_dir_path_fea2 = "datasets/dataset_working/feature_extraction/train_data_custom.csv"
output_dir_path_fea3 = "datasets/dataset_working/feature_extraction/test_data.csv"
output_dir_path_fea4 = "datasets/dataset_working/feature_extraction/test_data_custom.csv"
setwd('C:/Users/SrinathMannam/Desktop/Github/DataScienceR') # change path accordingly 

#import libraries
library(dplyr)

#Start of Train Data

#Read the features extracted
features_Data_train1 <- read.csv(file = csvLocation_train1)
features_Data_train2 <- read.csv(file = csvLocation_train2)

features_Data_train1 <- select(features_Data_train1, c(1,4:15))
features_Data_train2 <- select(features_Data_train2, c(4:28))

features_Data_train <- cbind(features_Data_train1, features_Data_train2)
features_Data_train <- features_Data_train %>% relocate(Target, .after = last_col())

features_Data_train_custom <- features_Data_train[!(features_Data_train$positive==0 & features_Data_train$negative==0),]

features_Data_train_custom <- features_Data_train_custom %>%
                                  mutate( Custom_Target = case_when(
                                    positive>=negative ~ 1,
                                    positive<negative ~ 0
                                  ))

features_Data_train <- features_Data_train[!(names(features_Data_train) %in% c('positive', 'negative'))]
features_Data_train_custom <- features_Data_train_custom[!(names(features_Data_train_custom) %in% c('positive', 'negative'))]


glimpse(features_Data_train)
glimpse(features_Data_train_custom)

#write to a csv file
write.csv(features_Data_train, output_dir_path_fea1)
write.csv(features_Data_train_custom, output_dir_path_fea2)

#End of Train Data

#Start of Test Data

#Read the features extracted
features_Data_test1 <- read.csv(file = csvLocation_test1)
features_Data_test2 <- read.csv(file = csvLocation_test2)

features_Data_test1 <- select(features_Data_test1, c(1,4:15))
features_Data_test2 <- select(features_Data_test2, c(4:28))

features_Data_test <- cbind(features_Data_test1, features_Data_test2)
features_Data_test <- features_Data_test %>% relocate(Target, .after = last_col())

features_Data_test_custom <- features_Data_test[!(features_Data_test$positive==0 & features_Data_test$negative==0),]

features_Data_test_custom <- features_Data_test_custom %>%
  mutate( Custom_Target = case_when(
    positive>=negative ~ 1,
    positive<negative ~ 0
  ))

features_Data_test <- features_Data_test[!(names(features_Data_test) %in% c('positive', 'negative'))]
features_Data_test_custom <- features_Data_test_custom[!(names(features_Data_test_custom) %in% c('positive', 'negative'))]

glimpse(features_Data_test)
glimpse(features_Data_test_custom)

#write to a csv file
write.csv(features_Data_test, output_dir_path_fea3)
write.csv(features_Data_test_custom, output_dir_path_fea4)

#End of Test Data