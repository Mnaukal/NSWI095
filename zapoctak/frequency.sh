#!/bin/bash

A='FS=""'
B='COUNT=1'
C='REGEX=".+"'
D="IGNORECASE=false"
SORT="-k2 -nr"

while getopts :cwn:ias arg; do
  case $arg in
    c ) A='FS=""';;
    w ) A="FS=' '";;
    n ) if echo $OPTARG | grep -q "^[0-9][0-9]*$"; then
          B="COUNT=$OPTARG";
        else echo "Wrong value for option -n: $OPTARG"; exit;
        fi;;
    i ) D="IGNORECASE=true";;
    a ) C='REGEX="^[[:alnum:]]+$"';;
    s ) SORT="-k1";;
    \? ) echo "Unknown option: $OPTARG"; exit;;
    : ) echo "Missing value for option $OPTARG"; exit;; 
  esac
done
shift `expr $OPTIND - 1`

#echo $A $B $C $D
#echo $@      

cat $@  | eval ./frequency.awk -v $A -v $B -v $C -v $D | sort -t$'\t' $SORT           # The dollar sign tells bash to use ANSI-C quoting
