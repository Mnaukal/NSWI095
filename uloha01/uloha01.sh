touch -d "7 days ago" /tmp/temp01
find -type f -newer /tmp/temp01
rm /tmp/temp01