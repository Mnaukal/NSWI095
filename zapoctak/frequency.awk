#!/usr/bin/awk -f 

BEGIN {
  LAST=""
  LOADED=0
  TOTAL=0
}

{
  for (i = 1; i <= NF; i++)
  {
    if(IGNORECASE)
      $i = tolower($i)
      
    if($i !~ REGEX)
      continue
  
    #print LAST $i
    if(LAST == "")
      LAST=$i
    else
      LAST=LAST FS $i
    LOADED++
    #print LAST
  
    if(LOADED < COUNT) {
      #print "continue - " LAST
      continue  
    }
    else
    {
      counts[LAST]++
      TOTAL++
      
      if (FS=="")
        LAST=substr(LAST, 2)
      else if (index(LAST, FS) == 0)
        LAST=""
      else
        LAST=substr(LAST, index(LAST, FS) + 1)
    }
  }  
}

END {
  for (key in counts)
  {
    print key ":\t" counts[key] "x\t" counts[key]*100/TOTAL "%"  
  }  
}