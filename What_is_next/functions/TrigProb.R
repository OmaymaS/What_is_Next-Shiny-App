# function to find trigram probability

TrigProb <- function(input){
  
  g <- input %>% 
    tolower() %>% 
    trimws()
  
  prob_final <- numeric(0)
  
  # get first two words of the trigram
  Tri_W12 <- gsub(" [a-z]+$","",g)        #remove last word
  
  # get the last word of the trigram
  Tri_W3 <- stri_extract_last_words(g)
  
  # get all records of trigrams starting with Tri_W12
  trig_group <- trig[trig_1==Tri_W12]
  kk <- trig_group[order(Updated_Freq, decreasing = T)]$trig_2[1:3]
  
  # check if any records were found
  if (nrow(trig_group)>0)
  {
    # get the trigram record ending with Tri_W3
    trig_record <- trig_group[trig_2==Tri_W3]
    
    # check if this record exists
    if (nrow(trig_record)>0){
      # if it exists: calculate the prob
      prob_final <- trig_record$Updated_Freq/sum(trig_group$Trigram_Freq) 
    }
    
    # otherwise, backoff to bigram
    else{
      beta_leftover <- 1-(sum(trig_group$Updated_Freq)/sum(trig_group$Trigram_Freq))
      
      # get the 2nd word of the trigram (to be the 1st of the bihram)
      Bi_W1 <- unlist(strsplit(g," "))[2]
      
      # get all records of bigrams starting with Bi_W1
      big_group <- big[big_1==Bi_W1]
      
      # check if any records were found
      if(nrow(big_group)>0)
        # get the record ending with Tri_W3
        big_record <- big_group[big_2==Tri_W3]    
      
      # check if this record exists
      if(nrow(big_record)>0){

        # get unobserved records in the trigrams from the bigram group
        big_unobserved <- big_group[!(big_2 %in% trig_group$trig_2)]
        
        # calculate the prob 
        prob_final <- beta_leftover*(big_record$Updated_Freq/
                                       sum(big_unobserved$Updated_Fre
                                       ))
        }
      
      # otherwise, backoff to unigram (here unig==unig_group )
      else {
        
        # get record with unigram==last word of the input trigram Tri_W3
        uni_record <- unig[Unigram==Tri_W3]
        
        # get unobserved unigrams in the trigrams
        unig_unobserved <- unig[!(Unigram %in% trig_group$trig_2)]
        
        # calculate the prob
        prob_final <- beta_leftover*(uni_record$Updated_Freq/
                                       sum(unig_unobserved$Updated_Fre
                                       ))
      }
    } 
  }
  
  res <- ifelse(length(prob_final)==0,-1,prob_final)
  
  if (res==-1){print("Input not found in the trigram model")}
  else {return(res)}
  
}
