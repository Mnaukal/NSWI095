#!/usr/bin/awk -f 

BEGIN {
  LAST=""
}

{
  for (i = 1; i <= NF; i++)
  {
    if(IGNORECASE)
      $i = tolower($i)
      
    if(LAST == "") {
      LAST=$i
      continue
    }
    
    CURRENT = $i
  
    counts[LAST][CURRENT]++
    sums[LAST]++
      
    LAST = CURRENT
  }  
}

END {
  n=asorti(sums, words) # sort all words occured in text
  for (i = 1; i <= n; i++) {
    WORD = words[i] # current word  
    printf "%s ", WORD
    
    #m=asorti(counts[WORD], sorted) # sort inner array for current word
    for (j = 1; j <= n; j++) {
      printf "%i ", counts[WORD][words[j]] #"%.1e " 
    }
    
    printf "%i\n", sums[WORD]
  }
}