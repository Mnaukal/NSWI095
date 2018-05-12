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
    n ) B='COUNT=$OPTARG';;
    i ) D="IGNORECASE=true";;
    a ) C='REGEX="^[[:alnum:]]+$"';;
    s ) SORT="-k1";;
  esac
done
shift `expr $OPTIND - 1`

#echo $A $B $C $D
#echo $@

cat $@  | eval ./frequency.awk -v $A -v $B -v $C -v $D | sort $SORT