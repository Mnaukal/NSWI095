pocet=0
while read x </etc/passwd
do
   pocet=`expr $pocet + 1`
done
echo $pocet