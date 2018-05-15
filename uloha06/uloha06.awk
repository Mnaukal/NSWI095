#!/usr/bin/awk -f

BEGIN {
	RS="<"
  FS=" "
	FOUND = true
  
  #Vypis("Ahoj &amp; &quot; &lt; &gt;")
}
/^a\s/ {
  FOUND = false  
}

/^a\s/,/^\/a/ && (FOUND == false) {
  for (i = 0; i <= NF; i++)
  {
    if(substr($i, 1, 6) == "href=\"") # href s uvozovkami
    {
      URL = substr($i, 7)
      URL = substr(URL, 1, index(URL, "\"") - 1)
      Vypis(URL)
      FOUND = true
      break       
    }
    else if (substr($i, 1, 5) == "href=") # href bez uvozovek
    {
      URL = substr($i, 6, length($i) - 5)
      konec_tagu = index(URL, ">");
      if(konec_tagu > 0)
        URL = substr(URL, 1, konec_tagu - 1)
      Vypis(URL)
      FOUND = true
      break
    }
  }
}

function Vypis(url)
{
  gsub("&amp;", "\\&", url)
  gsub("&quot;", "\"", url)
  gsub("&lt;", "<", url)
  gsub("&gt;", ">", url)
  print url
}
