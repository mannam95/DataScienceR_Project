
#importing required libraries
library(dplyr)
library(word2vec)
library(stylo)

#setting the value of path variable to feed to the word2vec model
#change path accordingly
path  <- "/Users/priyankasingh/tweets.csv"

#Setting Hyper-parameters for Model training
set.seed(10034)


#training the model with dimensions as 25 and 20 iterations
model <- word2vec(path, dim = 25, iter = 20)

#embedding for word2vec is created after model is trained
embedding <- as.matrix(model)

#writing the embedding in the csv file
write.csv(embedding,"/Users/priyankasingh/word2vec_embedding.csv")

#Testing of trained model by Predicting the most similar words by giving an input Hate Vector
#Predicting on basis of nearest neighbors
lookslike <- predict(model,c("Hate","discrimination","race","abuse","offensive","violent","threat"),5, type = "nearest")
lookslike

#Predicting on basis of embedding 
embedding_test <- predict(model,c("kick"),5, type = "embedding")
embedding_test
