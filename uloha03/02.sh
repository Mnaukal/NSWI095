cat /etc/passwd | {
   pocet=0
   while read x
   do
      pocet=`expr $pocet + 1`
   done
   echo $pocet
}