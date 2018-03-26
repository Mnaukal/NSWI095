#1

grep -i -e raven raven.txt
# pokud bychom nechtěli slovo "craven" -> 
#grep -i -w -e raven raven.txt

#2

grep -e "^$" raven.txt | wc -l

#3

grep -i -e "\(rep\|word\|more\)" raven.txt

#4

grep -i -e "p.*p.*ore" raven.txt

#5

grep -i -e "^[^A-Z]" raven.txt

#6

grep -c -i -e "-$" raven.txt

#7

grep -i -o -e "[a-z]*ore" raven.txt

#8

grep -i -o -e "\bf[a-z]*" raven.txt
#grep -i -o -e "\(^\| \)f[a-z]*" raven.txt

#9

grep -e "\b\([a-zA-Z]\)[a-zA-Z]* \1" raven.txt