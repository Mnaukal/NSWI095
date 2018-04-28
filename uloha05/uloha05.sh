#!/bin/bash

# 1.
find /etc -maxdepth 1 -type f -printf '%s %p\n' | sort -nr | head -n1 | cut -f2 -d' '

# 2.
find /var -type f -printf '%s %p\n' | sort -nr | head -n1  | cut -f2 -d' '

# 3. rekurzivní
find /etc -printf '%T@ %p\n' | sort -nr | head -n1 | cut -f2 -d' '

# 3. nerekurzivní
find /etc -maxdepth 1 -printf '%T@ %p\n' | sort -nr | head -n1 | cut -f2 -d' '