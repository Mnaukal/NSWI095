pocet=0;
cat /etc/passwd | while read x
do
   pocet=`expr $pocet + 1`
done
echo $pocet