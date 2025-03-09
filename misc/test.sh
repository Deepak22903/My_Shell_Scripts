read -r a
i=1
while [ $i -le $a ]; do
  touch abc$i.c
  i=$(expr $i + 1)
done
