#!/usr/bin/awk -f 

BEGIN {
  CURRENT=0
  srand()              
}

{
  #print $1 " " $NF
  CURRENT++
  WORD = $1
  sums[WORD] = $NF
  words[CURRENT] = WORD
  for (i = 2; i <= NF - 1; i++)
  {
    counts[CURRENT][i - 1] = $i / $NF
  }  
}

END {
  if(INCREASE)
  {
    for (i in counts)
      for (j in counts[i])
        counts[i][j] = (counts[i][j] + 1 / CURRENT) / 2 # increase all probabilities
  }

  FIRST_NUM = int(rand() * CURRENT) + 1
  printf "%s%s", words[FIRST_NUM], OFS
  LAST_NUM = FIRST_NUM
  
  for (i = 0; i < GENERATE; i++)
  {
    CURR_NUM = Next(LAST_NUM)
    printf "%s%s", words[CURR_NUM], OFS
    LAST_NUM = CURR_NUM    
  }
  printf "\n"
}

function Next(last)
{  
  random=rand()
  current_index=0
  probability_sum=0
  
  while (probability_sum <= random)
	{
  	current_index++ 
  	probability_sum = probability_sum + counts[last][current_index]
  }
  return current_index
}