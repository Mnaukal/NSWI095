pocet=0
while read x
do
   pocet=`expr $pocet + 1`
done </etc/passwd
echo $pocet