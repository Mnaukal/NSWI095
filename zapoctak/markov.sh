#!/bin/bash

A='FS=" "'
B='GENERATE=100'
C="IGNORECASE=false"
TABLE=false

while getopts :n:ita arg; do
  case $arg in
    n ) if echo $OPTARG | grep -q "^[0-9][0-9]*$"; then
          B="GENERATE=$OPTARG";
        else echo "Wrong value for option -n: $OPTARG"; exit;
        fi;;
    i ) C="IGNORECASE=true";;
    a ) E="-v INCREASE=true";;
    t ) TABLE=true;;    
    \? ) echo "Unknown option: $OPTARG"; exit;;
    : ) echo "Missing value for option $OPTARG"; exit;; 
  esac
done
shift `expr $OPTIND - 1`

#echo $A $B $C $D
#echo $@      

if [ $TABLE = true ]; then
  #echo "Probability table"
  cat $@ | eval ./markov_gen.awk -v $A -v $C
else
  #echo "generate"
  cat $@ | eval ./markov.awk -v $B $E
fi