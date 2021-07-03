
#importing required libraries
library(dplyr)
library(word2vec)
library(stylo)
library(ggplot2)
library(ggrepel)

#setting the value of path variable to feed to the word2vec model
#change path accordingly
path  <- "/Users/priyankasingh/tweets.csv"

#Setting Hyper-parameters for Model training
set.seed(10034)


#training the model with dimensions as 25 and 20 iterations
model <- word2vec(path, dim = 25, iter = 20)

#embedding for word2vec is created after model is trained
embedding <- as.matrix(model)


#converting the data in dataframes to feed in further steps
dendo <- embedding[unlist(lapply(lookslike, `[`, 'term2')), ]
df  <- data.frame(word = gsub("//.+", "", rownames(dendo)), 
                  xpos = gsub(".+//", "", rownames(dendo)), 
                  x = viz[, 1], y = viz[, 2], 
                  stringsAsFactors = FALSE)

#Creation of Interactive Scatterplot depicting the co-relations
plot_ly(df, x = ~x, y = ~y, type = "scatter", mode = 'text', text = ~word)
#End of ScatterPlot_Hate_Speech_Corelations.png