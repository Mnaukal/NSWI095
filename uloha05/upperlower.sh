#!/bin/bash

# Doufam, ze to funguje. Na Windows se to spatne testuje, kdyz filesystem neresi velikost pismen, takze to vzdycky ohlasi, ze soubor s prohozenymi velkymi a malymi existuje.

if [ $1 = "-r" ] 2>/dev/null; then
  #echo "-r"
  shift
  find "$@" -regex ".*/[^A-Z]*" -type f | while read puvodni; do
    #echo "puvodni" $puvodni
    nazev_velke=`echo $puvodni | sed 's=.*/==' | tr [a-z] [A-Z]`
    cesta=`echo $puvodni | sed 's=[^/]*$=='`
    novy="$cesta$nazev_velke"
    #echo "novy: $novy"
    if [ -e "$novy" ]; then
      echo "Chyba: kolize na soubor $novy" >&2
    else
      mv "$puvodni" "$novy"
    fi
  done
else
  #echo "bez -r"
  find "$@" -regex ".*/[^a-z]*" -type f | while read puvodni; do
    #echo "puvodni" $puvodni
    nazev_male=`echo $puvodni | sed 's=.*/==' | tr [A-Z] [a-z]`
    cesta=`echo $puvodni | sed 's=[^/]*$=='`
    novy="$cesta$nazev_male"
    #echo "novy: $novy"
    if [ -e "$novy" ]; then
      echo "Chyba: kolize na soubor $novy" >&2
    else
      mv "$puvodni" "$novy"
    fi
  done
fi 