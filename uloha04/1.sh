#!/bin/bash

sort -t'
' actor.txt -o actor.txt
sort -t'
' beverly_hills.txt -o beverly_hills.txt
sort -t'
' social.txt -o social.txt

join -t'
' -o 1.1 actor.txt beverly_hills.txt >join1.txt
join -t'
' -o 1.1 social.txt join1.txt