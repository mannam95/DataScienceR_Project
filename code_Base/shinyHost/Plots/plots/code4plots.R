1. ######################### start plot - scatterplot PCA ################
library(ggfortify)
authSig.pca <- prcomp(authorSignatures,  center = TRUE,scale. = TRUE) 
autoplot(authSig.pca, data = dataset, colour = 'AuthorSpreading') 
################### end plot - scatterplot PCA ################

2. ################## start plot - bar plot for all words ###########
theme_set(theme_minimal())
train_words_all %>%
  top_n(50, n) %>%
  arrange(n) %>%
  mutate(word = factor(word, levels = word)) %>%
  ggplot() +
  labs(y='Frequency of Words',x='Words')+
  geom_col(aes(word, n), color = "gray80", fill = "lightgreen") +
  coord_flip()
################## end plot - bar plot for all tweets ###########

3. #################### start plot- word usage #####################
train_words_target %>%
  group_by(AuthorSpreading) %>%
  top_n(20, n) %>%
  ungroup() %>%
  group_by(word) %>%
  mutate(tot_n = sum(n)) %>%
  ungroup() %>%
  arrange(desc(tot_n)) %>%
  mutate(word = factor(word, levels = rev(unique(word)))) %>%
  ggplot() +
  geom_point(aes(AuthorSpreading, word, size = n, color = n), show.legend = FALSE) +
  geom_text(aes(AuthorSpreading, word, label = n), hjust = -1) +
  scale_color_distiller(palette = "YlOrRd") +
  labs(y='Words Usage',x='Class')+
  scale_size_continuous(range = c(1, 10))
#################### end plot #####################

4,5 ############### start of bar plot - word cloud for hate and non hate #######################
TargetWordBars <- function(class) {
  train_words_target %>%
    filter(AuthorSpreading == class) %>%
    top_n(50, n) %>%
    arrange(n) %>%
    mutate(word = factor(word, levels = word)) %>%
    ggplot() +
    geom_col(aes(word, n), color = "gray80", fill = "lightgreen") +
    labs(x='Words',y='Word frequency')+
    coord_flip() 
}
4.#plot 1 
TargetWordBars('Hate')
5. #plot 2
TargetWordBars('Non-Hate')

###################### end plot ###########################

6. ##################### start plot - topics ###########################

top_terms %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip() + theme_bw()
##################### end plot ###########################


