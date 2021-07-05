#Start of sent_Plot.png

plot_ly(sentiment_types_df, y=~syuzhet, type="scatter", mode="jitter", name="syuzhet") %>%
  add_trace(y=~bing, mode="lines", name="bing") %>%
  add_trace(y=~afinn, mode="lines", name="afinn") %>%
  add_trace(y=~nrc, mode="lines", name="nrc") %>%
  layout(title="Different type of sentiments for Author Tweets",
         yaxis=list(title="Score"), xaxis=list(title="Number of tweets"))

#End of sent_Plot.png

#Start of emotions_Plot.png

ggplot(emotions_df_column_count_df, 
       aes(x = "", 
           y = percent, 
           fill = Different_Emotions)) +
  geom_bar(width = 1, 
           stat = "identity", 
           color = "black") +
  geom_text(aes(label = paste0(Different_Emotions, "\n", round(percent,2))),
            position = position_stack(vjust = 0.5),
            color = "black") +
  coord_polar("y", 
              start = 0, 
              direction = -1) +
  theme_void() +
  theme(legend.position = "FALSE") +
  labs(title = "Tweets Emotion Analysis")

#End of emotions_Plot.png

#Start of pos_neg_Plot.png

qplot(Sentiment, data=positive_df_column_count_df, weight=percent, geom="bar",fill=Sentiment, ylab="Percentage", xlab="Sentiment")+ggtitle("Tweets Sentiment Analysis")

#End of pos_neg_Plot.png

#Start of author_Plot.png

qplot(Different_Emotions, data=author_emotions_df_column_count_df, weight=percent, geom="bar",fill=Different_Emotions, ylab="Percentage", xlab="Emotions")+ggtitle("One Random Author Emotion Analysis")

#End of author_Plot.png