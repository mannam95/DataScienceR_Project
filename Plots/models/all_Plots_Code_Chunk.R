#Start of decision_Tree_Fit.png

fit <- rpart(Custom_Target~., data = data_train[!(names(data_train) %in% c('Author_Id', 'X', 'Target'))], method = 'class')
rpart.plot(fit, extra = 106)

#End of decision_Tree_Fit.png

#Start of train_dist.png

barplot(prop.table(table(data_train$Custom_Target)),
        col = "#219ebc",
        ylim = c(0,1),
        main = "Training Class Distribution")

#End of train_dist.png

#Start of test_dist.png

barplot(prop.table(table(data_test$Custom_Target)),
        col = "#8ecae6",
        ylim = c(0,1),
        main = "Test Class Distribution")

#End of test_dist.png