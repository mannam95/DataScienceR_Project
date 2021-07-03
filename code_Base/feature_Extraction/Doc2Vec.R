
#Code for generating doc2vec to produce Tweet2Vectors for all authors
#It will make use of paragraph2vec feature of the package

#importing required libraries
library(doc2vec)

#Reading pre-processed csv file
#change path accordingly
processed_data <- read.csv("/Users/priyankasingh/tweets.csv")

#indexing the doc and creating the dataframe
df <- data.frame(doc_id=1:29800,text = c(t(processed_data)))

#training model for doc2vec
# We are using Distributed Bag of Words Version of Paragraph Vector (PV-DBOW) keeping the dimensions as 25 and iterations as 20
model_para <- paragraph2vec(df, dim = 25, type = "PV-DBOW", iter = 20, min_count = 0, embeddings = embedding)

#writing the embedding results in matrix format
embedding_para <- as.matrix(model_para)

#reviewing the content of embedding_para
embedding_para

#storing the tweet2vec embeddings in a csv file
embedding_final <- data.frame(newcol=c(t(processed_data)),embedding_para)
write.csv(embedding_final,"/Users/priyankasingh/tweet2vec_feature_extraction.csv")

#writing the model on local for re-usability
write.csv(embedding_final,"/Users/priyankasingh/model_para")


