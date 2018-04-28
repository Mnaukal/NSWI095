#!/bin/bash

# max=`cat /etc/group | cut -f4 -d: | tr -cd , | wc -c | sort -nr | head -n1`
# neumím rozlišit mezi prázdnou skupinou a skupinou s jedním členem - obě mají stejný počet čárek

max=`cat /etc/group | cut -f4 -d: | sed 's/^$/,/;s/$/,/;s/,,//' | tr -cd ',\n' | sort -r | head -n1 | wc -c`
# tohle už by to umět mělo

#echo "$max"

while read radek
do
    aktualni=`echo $radek | cut -f4 -d: | sed 's/^$/,/;s/$/,/;s/,,//' | tr -cd  ',\n' | wc -c`
    if [ $aktualni -eq $max ]; then
        echo $radek | cut -f1 -d:
    fi
done </etc/group

# jen poznamky
#sed 's/[^,]*//g'
#tr -cd , | wc -c 
