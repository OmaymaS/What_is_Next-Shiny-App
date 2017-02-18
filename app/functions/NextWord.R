# function to predict the next word based on trigram model

NextWord <- function(input){
  
  g <- input %>% 
    tolower() %>% 
    trimws()
  
  prob_final <- numeric(0)
  
  # initiate result
  res <- ""
  
  input <- paste(word(input,-2),word(input,-1),sep=" ")
  
  # get all records of trigrams starting with input
  trig_group <- trig[trig_1==input]
  
  # check if any records were found
  if (nrow(trig_group)>0)
  {
    res <- trig_group[order(Updated_Freq, decreasing = T)]$trig_2[1:3] %>% na.omit()
    
    if (length(res)==3){
      return(res)
    }
    else{
      # beta_leftover <- trig[trig_1==input]$Leftover_Prob[1]
      beta_leftover <- 1-(sum(trig_group$Updated_Freq)/sum(trig_group$Trigram_Freq))
      
      big_group <- big[big_1==word(input,-1)] 
      
      if(nrow(big_group)>0){
        
        # get unobserved records in the trigrams from the bigram group
        big_unobserved <- big_group[!(big_2 %in% trig_group$trig_2)]
        
        # calculate the prob 
        big_unobserved[,"Prob":=beta_leftover*Updated_Freq/(sum(Updated_Freq))]
        
        mm <- ifelse(nrow(big_unobserved)<(3-(length(res))),
                     nrow(big_unobserved)
                     ,(3-(length(res))))
        # get top prob
        res_rest_big <- big_unobserved[order(Prob, decreasing = T),big_2][1:mm]
        
        res <- c(res,res_rest_big)
        
        if (length(res)==3){
          return(res)
        }
        
        else{

          # get unobserved unigrams in the trigrams
          unig_unobserved <- unig[!(Unigram %in% trig_group$trig_2)]
          
          # calculate the prob 
          unig_unobserved[,"Prob":=beta_leftover*Updated_Freq/(sum(Updated_Freq))]
          
          mm <- ifelse(nrow(unig_unobserved)<(3-(length(res))),
                       nrow(unig_unobserved)
                       ,(3-(length(res))))
          
          res_rest_unig <- unig_unobserved[order(Prob, decreasing = T)]$Unigram[1:mm]
          res <- c(res,res_rest_unig)
          
          
          return(res)
        }
      }
    }
  }
  
  else{ 
    #backoff to bigram
    big_group <- big[big_1==word(input,-1)] 
    
    if(nrow(big_group)>0){
      res <- big_group[order(Updated_Freq, decreasing = T)]$big_2[1:3] %>% na.omit()

      if (length(res)==3) {
        return(res)
      }
      
      else
      {
        # calculate beta leftover
        beta_leftove_big <- 1-sum(big_group$Updated_Freq)/sum(big_group$Bigram_Freq) 
        
        # get unobserved unigrams in the trigrams
        unig_unobserved <- unig[!(Unigram %in% big_group$big_2)]
        
        # calculate the prob 
        unig_unobserved[,"Prob":=beta_leftove_big*Updated_Freq/(sum(Updated_Freq))]
        
        mm <- ifelse(nrow(unig_unobserved)<(3-(length(res))),
                     nrow(unig_unobserved)
                     ,(3-(length(res))))
        
        res_rest_unig <- unig_unobserved[order(Prob, decreasing = T)]$Unigram[1:mm]
        res <- c(res,res_rest_unig)
        return(res)
        
      }
    }
    
    else{
      # return top unigrams (random, does not depend on history)
      res <- unig[order(Updated_Freq, decreasing = T)]$Unigram[1:3] %>% na.omit()
      return(res)
    }
  }
  
}



