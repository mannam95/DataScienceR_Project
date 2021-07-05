##This file contains the code chunks for plots created for exploratory data analysis



#Code chunck for creation of Dendogram by using clustering for words closest to the given input Hate Speech Vector
#Start of Cluster_Dendogram_For_Hate_Speech_Vector.png
dendo <- embedding[unlist(lapply(lookslike, `[`, 'term2')), ]
dendo_dist = dist.cosine(dendo) %>% as.dist
plot(as.dendrogram(hclust(dendo_dist)), horiz=F, cex=1, main="Cluster Dendogram of words closest to HateSpeech Vector")
# End of Cluster_Dendogram_For_Hate_Speech_Vector.png





#Code for creating Static Plot after reduction of word2vec in 2D
#Start of Static_Plot_Dimension_Reduction_2D_Using_UMAP_Word2Vec.jpeg
df  <- data.frame(word = gsub("//.+", "", rownames(dendo)), 
                  xpos = gsub(".+//", "", rownames(dendo)), 
                  x = viz[, 1], y = viz[, 2], 
                  stringsAsFactors = FALSE)

ggplot(df, aes(x = x, y = y, label = word)) + 
  geom_text_repel() + theme_void() + 
  labs(title = "word2vec - Visualization of Embeddings in 2D using UMAP")
#End of #Start of Static_Plot_Dimension_Reduction_2D_Using_UMAP_Word2Vec.jpeg




#Code of creation Interctive Scatterplot giving the Corelations of words 
#Start of ScatterPlot_Hate_Speech_Corelations.png
plot_ly(df, x = ~x, y = ~y, type = "scatter", mode = 'text', text = ~word)
#End of ScatterPlot_Hate_Speech_Corelations.png