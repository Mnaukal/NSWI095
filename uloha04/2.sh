#!/bin/bash

sort -t';' -k4  kodyzemi_cz.csv -o kodyzemi_cz.csv
sort -t';' -k1  countrycodes_en.csv -o countrycodes_en.csv

join -t';' -14 -21 -o 1.4 kodyzemi_cz.csv countrycodes_en.csv