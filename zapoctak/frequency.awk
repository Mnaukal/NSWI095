#!/usr/bin/awk -f 

BEGIN {

}

{
  for (i = 1; i <= NF; i++)
  {
    if(IGNORECASE)
      $i = tolower($i)
    
    #print $i " " "/"REGEX"/" " " ($i ~ REGEX)
      
    if($i ~ REGEX)  
      counts[$i]++;  
  }  
}

END {
  for (key in counts)
  {
    print key ":\t" counts[key] "x"  
  }  
}